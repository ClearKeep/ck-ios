//
//  UserService.swift
//  ChatSecure
//
//  Created by NamNH on 28/04/2022.
//

import Foundation
import SignalServiceKit
import Networking
import SwiftSRP
import Common
import GRPC
import CryptoTokenKit
import LibSignalClient

public protocol IUserService {
	func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error>
	func getUsers(domain: String) async -> (Result<User_GetUsersResponse, Error>)
	func searchUser(keyword: String, domain: String) async -> (Result<User_SearchUserResponse, Error>)
	func getUserInfo(clientID: String, workspaceDomain: String, domain: String) async -> (Result<User_UserInfoResponse, Error>)
	func getListStatus(data: [[String: String]], domain: String) async -> (Result<User_GetClientsStatusResponse, Error>)
	func searchUserWithEmail(email: String, domain: String) async -> (Result<User_UserInfoResponse, Error>)
	func pingRequest(domain: String) async -> Result<User_BaseResponse, Error>
	func updateStatus(status: String, domain: String) async -> Result<User_BaseResponse, Error>
	func uploadAvatar(fileName: String, fileContentType: String, fileData: Data, fileHash: String, domain: String) async -> (Result<User_UploadAvatarResponse, Error>)
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool, domain: String) async -> (Result<User_BaseResponse, Error>)
	func changePassword(oldPassword: String, newPassword: String, domain: String) async -> (Result<User_BaseResponse, Error>)
	func validatePassword(password: String, domain: String) async -> Result<User_MfaBaseResponse, Error>
	func mfaResendOTP(domain: String) async -> Result<User_MfaBaseResponse, Error>
	func mfaValidateOTP(otp: String, domain: String) async -> Result<User_MfaBaseResponse, Error>
	func getMfaState(domain: String) async -> Result<User_MfaStateResponse, Error>
	func updateMfaSettings(domain: String, enabled: Bool) async -> Result<User_MfaBaseResponse, Error>
	func deleteUser(domain: String) async -> Result<User_BaseResponse, Error>
}

public class UserService {
	var byteV: UnsafePointer<CUnsignedChar>?
	var usr: OpaquePointer?
	private let signalStore: ISignalProtocolInMemoryStore
	
	public init(signalStore: ISignalProtocolInMemoryStore) {
		self.signalStore = signalStore
	}
}

extension UserService: IUserService {
	public func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error> {
		let request = User_Empty()
		
		return await channelStorage.getChannel(domain: domain).getProfile(request)
	}
	
	public func getUsers(domain: String) async -> (Result<User_GetUsersResponse, Error>) {
		let request = User_Empty()
		
		return await channelStorage.getChannel(domain: domain).getUsers(request)
	}
	
	public func searchUser(keyword: String, domain: String) async -> (Result<User_SearchUserResponse, Error>) {
		var request = User_SearchUserRequest()
		request.keyword = keyword
		
		return await channelStorage.getChannel(domain: domain).searchUser(request)
	}
	
	public func getUserInfo(clientID: String, workspaceDomain: String, domain: String) async -> (Result<User_UserInfoResponse, Error>) {
		var request = User_GetUserRequest()
		request.clientID = clientID
		request.workspaceDomain = workspaceDomain
		
		return await channelStorage.getChannel(domain: domain).getUserInfo(request)
	}
	
	public func getListStatus(data: [[String: String]], domain: String) async -> (Result<User_GetClientsStatusResponse, Error>) {
		var request = User_GetClientsStatusRequest()
		let clients = data.map { item -> User_MemberInfoRequest in
			var client = User_MemberInfoRequest()
			client.clientID = item["id"] ?? ""
			client.workspaceDomain = item["domain"] ?? ""
			return client
		}
		request.lstClient = clients
		request.shouldGetProfile = true
		
		return await channelStorage.getChannel(domain: domain).getClientsStatus(request)
		
	}
	
	public func searchUserWithEmail(email: String, domain: String) async -> (Result<User_UserInfoResponse, Error>) {
		var request = User_FindUserByEmailRequest()
		request.email = email
		
		return await channelStorage.getChannel(domain: domain).searchUserWithEmail(request)
	}
	
	public func pingRequest(domain: String) async -> Result<User_BaseResponse, Error> {
		let request = User_PingRequest()
		return await channelStorage.getChannel(domain: domain).pingRequest(request)
	}
	
	public func updateStatus(status: String, domain: String) async -> Result<User_BaseResponse, Error> {
		var request = User_SetUserStatusRequest()
		request.status = status
		return await channelStorage.getChannel(domain: domain).updateStatus(request)
	}
	
	public func uploadAvatar(fileName: String, fileContentType: String, fileData: Data, fileHash: String, domain: String) async -> (Result<User_UploadAvatarResponse, Error>) {
		var request = User_UploadAvatarRequest()
		request.fileName = fileName
		request.fileContentType = fileContentType
		request.fileData = fileData
		request.fileHash = fileHash
		
		return await channelStorage.getChannel(domain: domain).uploadAvatar(request)
	}
	
	public func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool, domain: String) async -> (Result<User_BaseResponse, Error>) {
		var request = User_UpdateProfileRequest()
		request.avatar = avatar
		request.displayName = displayName
		request.phoneNumber = phoneNumber
		request.clearPhoneNumber_p = clearPhoneNumber
		return await channelStorage.getChannel(domain: domain).updateProfile(request)
	}
	
	public func changePassword(oldPassword: String, newPassword: String, domain: String) async -> (Result<User_BaseResponse, Error>) {
		guard let email = channelStorage.realmManager.getServer(by: domain)?.profile?.email else { return .failure(ServerError.unknown) }
		let srp = SwiftSRP.shared
		
		guard let aValue = srp.getA(userName: email, rawPassword: oldPassword, usr: &usr) else { return .failure(ServerError.unknown) }
		let aHex = bytesConvertToHexString(bytes: aValue)
		
		var request = User_RequestChangePasswordReq()
		request.clientPublic = aHex
		
		let response = await channelStorage.getChannel(domain: domain).requestChangePassword(request)
		
		switch response {
		case .success(let data):
			guard let mValue = await srp.getM(salt: data.salt.hexaBytes, byte: data.publicChallengeB.hexaBytes, usr: usr) else { return .failure(ServerError.unknown) }
			let mHex = bytesConvertToHexString(bytes: mValue)
			
			guard let newSalt = srp.getSalt(userName: email, rawPassword: newPassword, byteV: &byteV),
				  let verificator = srp.getVerificator(byteV: byteV) else { return(.failure(ServerError.unknown)) }
			let newSaltHex = bytesConvertToHexString(bytes: newSalt)
			let verificatorHex = bytesConvertToHexString(bytes: verificator)
			
			srp.freeMemoryAuthenticate(usr: &usr)
			
			let pbkdf2 = PBKDF2(passPharse: newPassword)
			
			guard let oldIdentityKey = try? signalStore.identityStore.identityKeyPair(context: NullContext()) else { return .failure(ServerError.unknown) }
			
			let encrypt = pbkdf2.encrypt(data: oldIdentityKey.privateKey.serialize(), saltHex: newSaltHex)
			
			var request = User_ChangePasswordRequest()
			request.clientPublic = aHex
			request.clientSessionKeyProof = mHex
			request.hashPassword = verificatorHex
			request.salt = newSaltHex
			request.ivParameter = bytesConvertToHexString(bytes: pbkdf2.iv)
			request.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
			
			let response = await channelStorage.getChannel(domain: domain).changePassword(request)
			switch response {
			case .success(let data):
				Debug.DLog("change password success")
				channelStorage.updateKeyServer(salt: newSaltHex, iv: bytesConvertToHexString(bytes: pbkdf2.iv), domain: domain)
				return(.success(data))
			case .failure(let error):
				Debug.DLog("change password fail - \(error)")
				return(.failure(error))
			}
		case .failure(let error):
			Debug.DLog("change password fail - \(error)")
			return(.failure(error))
		}
	}
	
	public func validatePassword(password: String, domain: String) async -> Result<User_MfaBaseResponse, Error> {
		guard let server = channelStorage.realmManager.getServer(by: domain) else { return .failure(ServerError.unknown) }
		let srp = SwiftSRP.shared
		
		guard let aValue = srp.getA(userName: server.profile?.email ?? "", rawPassword: password, usr: &usr) else { return .failure(ServerError.unknown) }
		let aHex = bytesConvertToHexString(bytes: aValue)
		
		var request = User_MfaAuthChallengeRequest()
		request.clientPublic = aHex
		
		let response = await channelStorage.getChannel(domain: domain).mfaAuthChallenge(request)
		
		switch response {
		case .success(let data):
			Debug.DLog("validate password mfa auth challenge success - \(data)")
			guard let mValue = await srp.getM(salt: data.salt.hexaBytes, byte: data.publicChallengeB.hexaBytes, usr: usr) else { return .failure(ServerError.unknown) }
			let mHex = bytesConvertToHexString(bytes: mValue)
			
			srp.freeMemoryAuthenticate(usr: &usr)
			
			var request = User_MfaValidatePasswordRequest()
			request.clientPublic = aHex
			request.clientSessionKeyProof = mHex
			
			let response = await channelStorage.getChannel(domain: domain).mfaValidatePassword(request)
			switch response {
			case .success(let data):
				Debug.DLog("validate password success - \(data)")
				return(.success(data))
			case .failure(let error):
				Debug.DLog("validate password fail - \(error)")
				return(.failure(error))
			}
		case .failure(let error):
			Debug.DLog("validate password fail - \(error)")
			return .failure(error)
		}
	}
	
	public func mfaResendOTP(domain: String) async -> Result<User_MfaBaseResponse, Error> {
		let request = User_MfaResendOtpRequest()
		let response = await channelStorage.getChannel(domain: domain).mfaResendOTP(request)
		switch response {
		case .success(let data):
			return(.success(data))
		case .failure(let error):
			return(.failure(error))
		}
	}
	
	public func mfaValidateOTP(otp: String, domain: String) async -> Result<User_MfaBaseResponse, Error> {
		var request = User_MfaValidateOtpRequest()
		request.otp = otp
		
		let response = await channelStorage.getChannel(domain: domain).mfaValidateOtp(request)
		switch response {
		case .success(let data):
			Debug.DLog("mfa validate otp success - \(data)")
			return(.success(data))
		case .failure(let error):
			Debug.DLog("mfa validate otp fail - \(error)")
			return(.failure(error))
		}
	}
	
	public func getMfaState(domain: String) async -> Result<User_MfaStateResponse, Error> {
		let request = User_MfaGetStateRequest()
		let response = await channelStorage.getChannel(domain: domain).getMFAState(request)
		switch response {
		case .success(let data):
			Debug.DLog("get mfa state success - \(data.mfaEnable)")
			return(.success(data))
		case .failure(let error):
			Debug.DLog("get mfa state fail - \(error)")
			return(.failure(error))
		}
	}
	
	public func updateMfaSettings(domain: String, enabled: Bool) async -> Result<User_MfaBaseResponse, Error> {
		let request = User_MfaChangingStateRequest()
		if enabled {
			return await channelStorage.getChannel(domain: domain).enableMFA(request)
		} else {
			return await channelStorage.getChannel(domain: domain).disableMFA(request)
		}
	}

	public func deleteUser(domain: String) async -> Result<User_BaseResponse, Error> {
		let request = User_Empty()
		return await channelStorage.getChannel(domain: domain).deleteUser(request)
	}
}

extension UserService {
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
