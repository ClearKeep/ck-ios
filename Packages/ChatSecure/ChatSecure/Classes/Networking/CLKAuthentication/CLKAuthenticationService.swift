//
//  CLKAuthenticationService.swift
//  
//
//  Created by NamNH on 11/03/2022.
//

import Foundation
import SignalProtocolObjC
import Networking
import SwiftSRP
import Common
import GRPC
import NIO
import NIOHPACK
import CryptoTokenKit

public enum SocialType {
	case google
	case facebook
	case office
}

public protocol IAuthenticationService {
	func register(displayName: String, email: String, password: String, domain: String) async -> Result<Auth_RegisterSRPRes, Error>
	func login(userName: String, password: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func registerSocialPin(rawPin: String, userId: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func verifySocialPin(rawPin: String, userId: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func resetSocialPin(rawPin: String, userId: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func recoverPassword(email: String, domain: String) async -> Result<Auth_BaseResponse, Error>
	func logoutFromAPI(domain: String) async -> Result<Auth_BaseResponse, Error>
	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func mfaResendOTP(userId: String, otpHash: String, domain: String) async -> Result<Auth_MfaResendOtpRes, Error>
}

public class CLKAuthenticationService {
	var byteV: UnsafePointer<CUnsignedChar>?
	var usr: OpaquePointer?
	var clientStore: ClientStore
	
	public init() {
		clientStore = ClientStore()
	}
}

// MARK: - Public
extension CLKAuthenticationService: IAuthenticationService {
	public func register(displayName: String, email: String, password: String, domain: String) async -> Result<Auth_RegisterSRPRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let salt = srp.getSalt(userName: email, rawPassword: password, byteV: &byteV),
			  let verificator = srp.getVerificator(byteV: byteV) else { return(.failure(ServerError.unknown)) }
		let saltHex = bytesConvertToHexString(bytes: salt)
		let verificatorHex = bytesConvertToHexString(bytes: verificator)
		
		srp.freeMemoryCreateAccount(byteV: &byteV)
		
		let pbkdf2 = PBKDF2(passPharse: password)
		let inMemoryStore: SignalInMemoryStore = SignalInMemoryStore()
		let storage = SignalStorage(signalStore: inMemoryStore)
		let context = SignalContext(storage: storage)
		guard let keyHelper = SignalKeyHelper(context: context ?? SignalContext()),
			  let key = keyHelper.generateIdentityKeyPair() else { return(.failure(ServerError.unknown)) }
		
		let preKeys = keyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		
		guard let preKey = preKeys.first,
			  let preKeyData = preKey.serializedData(),
			  let signedPreKey = keyHelper.generateSignedPreKey(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (email + domain).hashCode())),
			  let signedPreKeyData = signedPreKey.serializedData() else { return(.failure(ServerError.unknown)) }
		
		var transitionId = keyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = key.publicKey
		peerRegisterClientKeyRequest.preKey = preKeyData
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.preKeyId)
		peerRegisterClientKeyRequest.signedPreKey = signedPreKeyData
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKey.preKeyId)
		let encrypt = pbkdf2.encrypt(data: [UInt8](key.privateKey), saltHex: saltHex)
		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = signedPreKey.signature
		
		var request = Auth_RegisterSRPReq()
		request.workspaceDomain = domain
		request.email = email
		request.passwordVerifier = verificatorHex
		request.salt = saltHex
		request.displayName = displayName
		request.authType = 0
		request.firstName = ""
		request.lastName = ""
		request.clientKeyPeer = peerRegisterClientKeyRequest
		request.ivParameter = bytesConvertToHexString(bytes: pbkdf2.iv)
		
		let response = await channelStorage.getChannel(domain: domain).registerSRP(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func login(userName: String, password: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let aValue = srp.getA(userName: userName, rawPassword: password, usr: &usr) else { return .failure(ServerError.unknown) }
		let aHex = bytesConvertToHexString(bytes: aValue)
		
		var request = Auth_AuthChallengeReq()
		request.email = userName
		request.clientPublic = aHex
		
		let response = await channelStorage.getChannel(domain: domain).login(request)
		
		switch response {
		case .success(let data):
			guard let mValue = await srp.getM(salt: data.salt.hexaBytes, byte: data.publicChallengeB.hexaBytes, usr: usr) else { return .failure(ServerError.unknown) }
			let mHex = bytesConvertToHexString(bytes: mValue)
			
			srp.freeMemoryAuthenticate(usr: &usr)
			
			var request = Auth_AuthenticateReq()
			request.userName = userName
			request.clientPublic = aHex
			request.clientSessionKeyProof = mHex
			
			let response = await channelStorage.getChannel(domain: domain).login(request)
			
			switch response {
			case .success(let authenResponse):
				var request = User_Empty()
				
				let response = await channelStorage.getChannel(domain: domain, accessToken: authenResponse.accessToken, hashKey: authenResponse.hashKey).getProfile(request)
				
				switch response {
				case .success(let profileResponse):
					channelStorage.realmManager.saveServer(profileResponse: profileResponse, authenResponse: authenResponse)
				case .failure(let error):
					break
				}
			case .failure:
				break
			}
			return response
		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func registerSocialPin(rawPin: String, userId: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let salt = srp.getSalt(userName: userId, rawPassword: rawPin, byteV: &byteV),
			  let verificator = srp.getVerificator(byteV: byteV) else { return .failure(ServerError.unknown) }
		let saltHex = bytesConvertToHexString(bytes: salt)
		let verificatorHex = bytesConvertToHexString(bytes: verificator)
		
		srp.freeMemoryCreateAccount(byteV: &byteV)
		
		let pbkdf2 = PBKDF2(passPharse: rawPin)
		let inMemoryStore: SignalInMemoryStore = SignalInMemoryStore()
		let storage = SignalStorage(signalStore: inMemoryStore)
		let context = SignalContext(storage: storage)
		guard let keyHelper = SignalKeyHelper(context: context ?? SignalContext()),
			  let key = keyHelper.generateIdentityKeyPair() else { return .failure(ServerError.unknown) }
		
		let preKeys = keyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		
		guard let preKey = preKeys.first,
			  let preKeyData = preKey.serializedData(),
			  let signedPreKey = keyHelper.generateSignedPreKey(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (userId + domain).hashCode())),
			  let signedPreKeyData = signedPreKey.serializedData() else { return .failure(ServerError.unknown) }
		
		var transitionId = keyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = key.publicKey
		peerRegisterClientKeyRequest.preKey = preKeyData
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.preKeyId)
		peerRegisterClientKeyRequest.signedPreKey = signedPreKeyData
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKey.preKeyId)
		let encrypt = pbkdf2.encrypt(data: [UInt8](key.privateKey), saltHex: saltHex)
		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = signedPreKey.signature
		
		var request = Auth_RegisterPinCodeReq()
		request.userName = userId
		request.hashPincode = verificatorHex
		request.salt = saltHex
		request.clientKeyPeer = peerRegisterClientKeyRequest
		request.ivParameter = bytesConvertToHexString(bytes: pbkdf2.iv)
		
		let response = await channelStorage.getChannel(domain: domain).registerPinCode(request)
		
		switch response {
		case .success(let authenResponse):
			var request = User_Empty()
			
			let response = await channelStorage.getChannel(domain: domain, accessToken: authenResponse.accessToken, hashKey: authenResponse.hashKey).getProfile(request)
			
			switch response {
			case .success(let profileResponse):
				channelStorage.realmManager.saveServer(profileResponse: profileResponse, authenResponse: authenResponse)
			case .failure(let error):
				break
			}
		case .failure:
			break
		}
		
		return response
	}
	
	public func verifySocialPin(rawPin: String, userId: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let aValue = srp.getA(userName: userId, rawPassword: rawPin, usr: &usr) else { return .failure(ServerError.unknown) }
		let aHex = bytesConvertToHexString(bytes: aValue)
		
		var request = Auth_AuthSocialChallengeReq()
		request.userName = userId
		request.clientPublic = aHex
		
		let response = await channelStorage.getChannel(domain: domain).login(request)
		
		switch response {
		case .success(let data):
			guard let mValue = await srp.getM(salt: data.salt.hexaBytes, byte: data.publicChallengeB.hexaBytes, usr: usr) else { return .failure(ServerError.unknown) }
			let mHex = bytesConvertToHexString(bytes: mValue)
			
			srp.freeMemoryAuthenticate(usr: &usr)
			
			var request = Auth_VerifyPinCodeReq()
			request.userName = userId
			request.clientPublic = aHex
			request.clientSessionKeyProof = mHex
			
			let response = await channelStorage.getChannel(domain: domain).verifyPinCode(request)
			switch response {
			case .success(let authenResponse):
				var request = User_Empty()
				
				let response = await channelStorage.getChannel(domain: domain, accessToken: authenResponse.accessToken, hashKey: authenResponse.hashKey).getProfile(request)
				
				switch response {
				case .success(let profileResponse):
					channelStorage.realmManager.saveServer(profileResponse: profileResponse, authenResponse: authenResponse)
				case .failure(let error):
					break
				}
			case .failure:
				break
			}
			
			return response
		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func resetSocialPin(rawPin: String, userId: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let salt = srp.getSalt(userName: userId, rawPassword: rawPin, byteV: &byteV),
			  let verificator = srp.getVerificator(byteV: byteV) else { return .failure(ServerError.unknown) }
		let saltHex = bytesConvertToHexString(bytes: salt)
		let verificatorHex = bytesConvertToHexString(bytes: verificator)
		
		srp.freeMemoryCreateAccount(byteV: &byteV)
		
		let pbkdf2 = PBKDF2(passPharse: rawPin)
		let inMemoryStore: SignalInMemoryStore = SignalInMemoryStore()
		let storage = SignalStorage(signalStore: inMemoryStore)
		let context = SignalContext(storage: storage)
		guard let keyHelper = SignalKeyHelper(context: context ?? SignalContext()),
			  let key = keyHelper.generateIdentityKeyPair() else { return .failure(ServerError.unknown) }
		
		let preKeys = keyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		
		guard let preKey = preKeys.first,
			  let preKeyData = preKey.serializedData(),
			  let signedPreKey = keyHelper.generateSignedPreKey(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (userId + domain).hashCode())),
			  let signedPreKeyData = signedPreKey.serializedData() else { return .failure(ServerError.unknown) }
		
		var transitionId = keyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = key.publicKey
		peerRegisterClientKeyRequest.preKey = preKeyData
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.preKeyId)
		peerRegisterClientKeyRequest.signedPreKey = signedPreKeyData
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKey.preKeyId)
		let encrypt = pbkdf2.encrypt(data: [UInt8](key.privateKey), saltHex: saltHex)
		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = signedPreKey.signature
		
		var request = Auth_RegisterPinCodeReq()
		request.userName = userId
		request.hashPincode = verificatorHex
		request.salt = saltHex
		request.clientKeyPeer = peerRegisterClientKeyRequest
		request.ivParameter = bytesConvertToHexString(bytes: pbkdf2.iv)
		
		let response = await channelStorage.getChannel(domain: domain).registerPinCode(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let salt = srp.getSalt(userName: email, rawPassword: rawNewPassword, byteV: &byteV),
			  let verificator = srp.getVerificator(byteV: byteV) else { return .failure(ServerError.unknown) }
		let saltHex = bytesConvertToHexString(bytes: salt)
		let verificatorHex = bytesConvertToHexString(bytes: verificator)
		
		srp.freeMemoryCreateAccount(byteV: &byteV)
		
		let pbkdf2 = PBKDF2(passPharse: rawNewPassword)
		let inMemoryStore: SignalInMemoryStore = SignalInMemoryStore()
		let storage = SignalStorage(signalStore: inMemoryStore)
		let context = SignalContext(storage: storage)
		guard let keyHelper = SignalKeyHelper(context: context ?? SignalContext()),
			  let key = keyHelper.generateIdentityKeyPair() else { return .failure(ServerError.unknown) }
		
		let preKeys = keyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		
		guard let preKey = preKeys.first,
			  let preKeyData = preKey.serializedData(),
			  let signedPreKey = keyHelper.generateSignedPreKey(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (email + domain).hashCode())),
			  let signedPreKeyData = signedPreKey.serializedData() else { return .failure(ServerError.unknown) }
		
		var transitionId = keyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = key.publicKey
		peerRegisterClientKeyRequest.preKey = preKeyData
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.preKeyId)
		peerRegisterClientKeyRequest.signedPreKey = signedPreKeyData
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKey.preKeyId)
		let encrypt = pbkdf2.encrypt(data: [UInt8](key.privateKey), saltHex: saltHex)
		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = signedPreKey.signature
		
		var request = Auth_ForgotPasswordUpdateReq()
		request.preAccessToken = domain
		request.email = email
		request.passwordVerifier = verificatorHex
		request.salt = saltHex
		request.clientKeyPeer = peerRegisterClientKeyRequest
		request.ivParameter = bytesConvertToHexString(bytes: pbkdf2.iv)
		
		let response = await channelStorage.getChannel(domain: domain).forgotPasswordUpdate(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func recoverPassword(email: String, domain: String) async -> Result<Auth_BaseResponse, Error> {
		var request = Auth_ForgotPasswordReq()
		request.email = email
		
		let response = await channelStorage.getChannel(domain: domain).forgotPassword(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func logoutFromAPI(domain: String) async -> Result<Auth_BaseResponse, Error> {
		guard let server = channelStorage.realmManager.getServer(by: domain) else { return .failure(ServerError.unknown) }
		
		var request = Auth_LogoutReq()
		request.deviceID = clientStore.getUniqueDeviceId()
		request.refreshToken = server.refreshToken
		
		let response = await channelStorage.getChannel(domain: server.serverDomain).logout(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		var request = Auth_MfaValidateOtpRequest()
		request.preAccessToken = otpHash
		request.userID = userId
		
		let response = await channelStorage.getChannel(domain: domain).validateOTP(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func mfaResendOTP(userId: String, otpHash: String, domain: String) async -> Result<Auth_MfaResendOtpRes, Error> {
		var request = Auth_MfaResendOtpReq()
		request.preAccessToken = otpHash
		request.userID = userId
		
		let response = await channelStorage.getChannel(domain: domain).mfaResendOTP(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
}

// MARK: - Private
private extension CLKAuthenticationService {
	func onLoginSuccess(_ response: Auth_AuthRes, password: String) {
//		var accessToken = response.accessToken
//		var domain = response.workspaceDomain
//		var salt = response.salt
//		var publicKey = response.clientKeyPeer.identityKeyPublic
//		var privateKeyEncrypt = response.clientKeyPeer.identityKeyEncrypted
//		var iv = response.ivParameter
//		var privateKeyDecrypt = PBKDF2(passPharse: password).decrypt(data: privateKeyEncrypt.hexaBytes, saltEncrypt: salt.hexaBytes, ivParameterSpec: iv.hexaBytes)
//		var preKey = response.clientKeyPeer.preKey
//		var preKeyId = response.clientKeyPeer.preKeyID
//		var preKeyRecord = CKSignalCoordinate.shared.ourEncryptionManager?.storage.storePreKey(preKey, preKeyId: UInt32(preKeyId))
//		var signedPreKeyId = response.clientKeyPeer.signedPreKeyID
//		var signedPreKey = response.clientKeyPeer.signedPreKey
//		var signedPreKeyRecord =  CKSignalCoordinate.shared.ourEncryptionManager?.storage.storePreKey(signedPreKey, preKeyId: UInt32(signedPreKeyId))
//		var registrationID = response.clientKeyPeer.registrationID
//		var clientId = response.clientKeyPeer.clientID
//		
//		var ecPublicKey = SignalKeyPair(
//		var eCPublicKey: ECPublicKey =
//		Curve.decodePoint(publicKey.toByteArray(), 0)
//		var eCPrivateKey: ECPrivateKey =
//		Curve.decodePrivatePoint(privateKeyDecrypt)
//		var identityKeyPair = IdentityKeyPair(IdentityKey(eCPublicKey), eCPrivateKey)
//		var signalIdentityKey =
//		SignalIdentityKey(
//			identityKeyPair,
//			registrationID,
//		domain,
//			clientId,
//			response.ivParameter,
//			salt
//		)
//		var profile = getProfile(
//			paramAPIProvider.provideUserBlockingStub(
//				ParamAPI(
//					domain,
//					accessToken,
//					hashKey
//				)
//			)
//		)
//		
//		signalIdentityKeyDAO.insert(signalIdentityKey)
//		
//		environment.setUpTempDomain(
//			Server(
//				null,
//				"",
//				domain,
//				profile.userId,
//				"",
//				0L,
//				"",
//				"",
//				"",
//				false,
//				Profile(null, profile.userId, "", "", "", 0L, "")
//			)
//		)
//		myStore.storePreKey(preKeyID, preKeyRecord)
//		myStore.storeSignedPreKey(signedPreKeyId, signedPreKeyRecord)
//		
//		if (clearOldUserData) {
//			var oldServer = serverRepository.getServerByDomain(domain)
//			
//			oldServer?.id?.let {
//				roomRepository.removeGroupByDomain(domain, profile.userId)
//				messageRepository.clearMessageByDomain(domain, profile.userId)
//			}
//		}
//		
//		var server = Server(
//			serverName = response.workspaceName,
//			serverDomain = domain,
//			ownerClientId = profile.userId,
//			serverAvatar = "",
//			loginTime = getCurrentDateTime().time,
//			accessKey = accessToken,
//			hashKey = hashKey,
//			refreshToken = response.refreshToken,
//			profile = profile,
//		)
//		
//		serverRepository.insertServer(server)
//		serverRepository.setActiveServer(server)
//		userPreferenceRepository.initDefaultUserPreference(
//			domain,
//			profile.userId,
//			isSocialAccount
//		)
//		userKeyRepository.insert(UserKey(domain, profile.userId, salt, iv))
//		
//		return Resource.success(response)
	}
	
	func getProfile(userGRPC: String) {
		
	}
	
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
