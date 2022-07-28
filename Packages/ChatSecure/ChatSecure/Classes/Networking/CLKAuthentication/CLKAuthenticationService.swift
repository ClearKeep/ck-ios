//
//  CLKAuthenticationService.swift
//  
//
//  Created by NamNH on 11/03/2022.
//

import Foundation
import SignalServiceKit
import Networking
import SwiftSRP
import Common
import GRPC
import CryptoTokenKit
import LibSignalClient

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
	private let signalStore: ISignalProtocolInMemoryStore
	
	public init(signalStore: ISignalProtocolInMemoryStore, clientStore: ClientStore) {
		self.clientStore = clientStore
		self.signalStore = signalStore
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
		
		let key = KeyHelper.generateIdentityKeyPair()
		let preKeys = KeyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		guard let preKey = preKeys.first,
			  let signedPreKeyRecord = KeyHelper.generateSignedPreKeyRecord(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (email + domain).hashCode()))
		else { return(.failure(ServerError.unknown)) }

		let preKeyData = preKey.serialize()
		let signedPrekeyRecordData = signedPreKeyRecord.serialize()

		var transitionId = KeyHelper.generateRegistrationId()

		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = Data(key.publicKey.serialize())
		peerRegisterClientKeyRequest.preKey = Data(preKeyData)
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.id)
		peerRegisterClientKeyRequest.signedPreKey = Data(signedPrekeyRecordData)
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKeyRecord.id)
		let encrypt = pbkdf2.encrypt(data: key.privateKey.serialize(), saltHex: saltHex)

		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = Data(signedPreKeyRecord.signature)

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
					await channelStorage.realmManager.saveServer(profileResponse: profileResponse, authenResponse: authenResponse)
					let result = onLoginSuccess(authenResponse, password: password)
					switch result {
					case .success(let value):
						return .success(authenResponse)
					case .failure(let error):
						return .failure(error)
					}
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
		
		let key = KeyHelper.generateIdentityKeyPair()
		let preKeys = try KeyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		guard let preKey = preKeys.first,
			  let signedPreKeyRecord = try KeyHelper.generateSignedPreKeyRecord(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (userId + domain).hashCode()))
		else { return(.failure(ServerError.unknown)) }

		let preKeyData = preKey.serialize()
		let signedPrekeyRecordData = signedPreKeyRecord.serialize()
		
		var transitionId = KeyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = Data(key.publicKey.serialize())
		peerRegisterClientKeyRequest.preKey = Data(preKeyData)
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.id)
		peerRegisterClientKeyRequest.signedPreKey = Data(signedPrekeyRecordData)
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKeyRecord.id)
		let encrypt = pbkdf2.encrypt(data: key.privateKey.serialize(), saltHex: saltHex)

		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = Data(signedPreKeyRecord.signature)

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
		
		let key = KeyHelper.generateIdentityKeyPair()
		let preKeys = try KeyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		guard let preKey = preKeys.first,
			  let signedPreKeyRecord = try KeyHelper.generateSignedPreKeyRecord(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (userId + domain).hashCode()))
		else { return(.failure(ServerError.unknown)) }
		
		let preKeyData = preKey.serialize()
		let signedPrekeyRecordData = signedPreKeyRecord.serialize()

		var transitionId = KeyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = Data(key.publicKey.serialize())
		peerRegisterClientKeyRequest.preKey = Data(preKeyData)
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.id)
		peerRegisterClientKeyRequest.signedPreKey = Data(signedPrekeyRecordData)
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKeyRecord.id)
		let encrypt = pbkdf2.encrypt(data: key.privateKey.serialize(), saltHex: saltHex)

		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = Data(signedPreKeyRecord.signature)

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
		
		let key = KeyHelper.generateIdentityKeyPair()
		let preKeys = try KeyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		guard let preKey = preKeys.first,
			  let signedPreKeyRecord = try KeyHelper.generateSignedPreKeyRecord(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (email + domain).hashCode()))
		else { return(.failure(ServerError.unknown)) }
		
		let preKeyData = preKey.serialize()
		let signedPrekeyRecordData = signedPreKeyRecord.serialize()

		var transitionId = KeyHelper.generateRegistrationId()
		var peerRegisterClientKeyRequest = Auth_PeerRegisterClientKeyRequest()
		peerRegisterClientKeyRequest.deviceID = Int32(Constants.senderDeviceId)
		peerRegisterClientKeyRequest.registrationID = Int32(bitPattern: transitionId)
		peerRegisterClientKeyRequest.identityKeyPublic = Data(key.publicKey.serialize())
		peerRegisterClientKeyRequest.preKey = Data(preKeyData)
		peerRegisterClientKeyRequest.preKeyID = Int32(bitPattern: preKey.id)
		peerRegisterClientKeyRequest.signedPreKey = Data(signedPrekeyRecordData)
		peerRegisterClientKeyRequest.signedPreKeyID = Int32(bitPattern: signedPreKeyRecord.id)
		let encrypt = pbkdf2.encrypt(data: key.privateKey.serialize(), saltHex: saltHex)

		peerRegisterClientKeyRequest.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
		peerRegisterClientKeyRequest.signedPreKeySignature = Data(signedPreKeyRecord.signature)

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
		
		let response = await channelStorage.getChannel(domain: server.serverDomain, accessToken: server.accessKey, hashKey: server.hashKey).logout(request)
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
	func onLoginSuccess(_ response: Auth_AuthRes, password: String) -> Result<Bool, Error> {
		do {
			let accessToken = response.accessToken
			let domain = response.workspaceDomain
			let salt = response.salt
			let privateKeyEncrypt = response.clientKeyPeer.identityKeyEncrypted
			let iv = response.ivParameter
			let privateKeyDecrypt = PBKDF2(passPharse: password).decrypt(data: privateKeyEncrypt.hexaBytes, saltEncrypt: salt.hexaBytes, ivParameterSpec: iv.hexaBytes)
			let preKey = response.clientKeyPeer.preKey
			let preKeyId = response.clientKeyPeer.preKeyID
			let preKeyRecord = try PreKeyRecord(bytes: preKey)
			let signedPreKeyId = response.clientKeyPeer.signedPreKeyID
			let signedPreKey = response.clientKeyPeer.signedPreKey
			let signedPreKeyRecord = try SignedPreKeyRecord(bytes: signedPreKey)
			let registrationID = response.clientKeyPeer.registrationID
			let clientId = response.clientKeyPeer.clientID
			
			let publicKey = try PublicKey(response.clientKeyPeer.identityKeyPublic)
			let privateKey = try PrivateKey(privateKeyDecrypt ?? [])
			let identityKeyPair = IdentityKeyPair(publicKey: publicKey, privateKey: privateKey)
			let identityKeyPairData = Data(identityKeyPair.serialize())
			let signalIdentityKey = SignalIdentityKey(
				identityKeyPair: identityKeyPairData,
				registrationId: UInt32(bitPattern: registrationID),
				domain: domain,
				userId: clientId)
			
			try signalStore.saveUserIdentity(identity: signalIdentityKey)
			try signalStore.saveUserPreKey(preKey: preKeyRecord, id: UInt32(bitPattern: preKeyId))
			try signalStore.saveUserSignedPreKey(signedPreKey: signedPreKeyRecord, id: UInt32(bitPattern: signedPreKeyId))
			return .success(true)
		} catch {
			return .failure(error)
		}
	}
	
	func getProfile(userGRPC: String) {
		
	}
	
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
