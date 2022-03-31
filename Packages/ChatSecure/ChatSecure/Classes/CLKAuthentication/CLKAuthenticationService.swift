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

public enum SocialType {
	case google
	case facebook
	case office
}

public protocol IAuthenticationService {
	func register(displayName: String, email: String, password: String, domain: String) async
	func login(userName: String, password: String, domain: String) async -> Result<Auth_AuthRes, Error>
	func login(by socicalType: SocialType, token: String, domain: String)
	func registerSocialPin(rawPin: String, userId: String, domain: String)
	func verifySocialPin(rawPin: String, userId: String, domain: String)
	func resetSocialPin(rawPin: String, userId: String, domain: String)
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String)
	func recoverPassword(email: String, domain: String)
	func logoutFromAPI(server: IServer)
	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String)
	func mfaResendOTP(userId: String, otpHash: String, domain: String)
}

public class CLKAuthenticationService {
	var byteV: UnsafePointer<CUnsignedChar>?
	var usr: OpaquePointer?
	
	public init() {}
}

// MARK: - Public
extension CLKAuthenticationService: IAuthenticationService {
	public func register(displayName: String, email: String, password: String, domain: String) async {
		let srp = SwiftSRP.shared
		
		guard let salt = srp.getSalt(userName: email, rawPassword: password, byteV: &byteV),
			  let verificator = srp.getVerificator(byteV: byteV) else { return }
		let saltHex = bytesConvertToHexString(bytes: salt)
		let verificatorHex = bytesConvertToHexString(bytes: verificator)
		
		srp.freeMemoryCreateAccount(byteV: &byteV)
		
		let pbkdf2 = PBKDF2(passPharse: password)
		let inMemoryStore: SignalInMemoryStore = SignalInMemoryStore()
		let storage = SignalStorage(signalStore: inMemoryStore)
		let context = SignalContext(storage: storage)
		guard let keyHelper = SignalKeyHelper(context: context ?? SignalContext()),
			  let key = keyHelper.generateIdentityKeyPair() else { return }
		
		let preKeys = keyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
		
		guard let preKey = preKeys.first,
			  let preKeyData = preKey.serializedData(),
			  let signedPreKey = keyHelper.generateSignedPreKey(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (email + domain).hashCode())),
			  let signedPreKeyData = signedPreKey.serializedData() else { return }
		
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
		
		let response = await channelStorage.getChannels(domain: domain).registerSRP(request)
		switch response {
		case .success(let data):
			print(data)
		case .failure(let error):
			print(error)
		}
	}
	
	public func login(userName: String, password: String, domain: String) async -> Result<Auth_AuthRes, Error> {
		let srp = SwiftSRP.shared
		
		guard let aValue = srp.getA(userName: userName, rawPassword: password, usr: &usr) else { return .failure(ServerError.unknown) }
		let aHex = bytesConvertToHexString(bytes: aValue)
		
		var request = Auth_AuthChallengeReq()
		request.email = userName
		request.clientPublic = aHex
		
		let response = await channelStorage.getChannels(domain: domain).login(request)
		
		switch response {
		case .success(let data):
			guard let mValue = await srp.getM(salt: data.salt.decodeHex, byte: data.publicChallengeB.decodeHex, usr: usr) else { return .failure(ServerError.unknown) }
			let mHex = bytesConvertToHexString(bytes: mValue)
			
			srp.freeMemoryAuthenticate(usr: &usr)
			
			var request = Auth_AuthenticateReq()
			request.userName = userName
			request.clientPublic = aHex
			request.clientSessionKeyProof = mHex
			
			return await channelStorage.getChannels(domain: domain).login(request)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func login(by socicalType: SocialType, token: String, domain: String) {
	}
	
	public func registerSocialPin(rawPin: String, userId: String, domain: String) {
	}
	
	public func verifySocialPin(rawPin: String, userId: String, domain: String) {
	}
	
	public func resetSocialPin(rawPin: String, userId: String, domain: String) {
	}
	
	public func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) {
	}
	
	public func recoverPassword(email: String, domain: String) {
	}
	
	public func logoutFromAPI(server: IServer) {
	}
	
	public func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) {
	}
	
	public func mfaResendOTP(userId: String, otpHash: String, domain: String) {
	}
}

// MARK: - Private
private extension CLKAuthenticationService {
	func onLoginSuccess() {
		
	}
	
	func getProfile(userGRPC: String) {
		
	}
	
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
