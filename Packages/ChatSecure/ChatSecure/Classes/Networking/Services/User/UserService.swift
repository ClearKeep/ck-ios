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
	func getListStatus(ids: [String], workspaceDomain: String, domain: String) async -> (Result<User_GetClientsStatusResponse, Error>)
	func searchUserWithEmail(emailHash: String, domain: String) async -> (Result<User_FindUserByEmailResponse, Error>)
	func pingRequest(domain: String) async -> Result<User_BaseResponse, Error>
	func updateStatus(status: String, domain: String) async -> Result<User_BaseResponse, Error>
	func uploadAvatar(fileName: String, fileContentType: String, fileData: Data, fileHash: String, domain: String) async -> (Result<User_UploadAvatarResponse, Error>)
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool, domain: String) async -> (Result<User_BaseResponse, Error>)
	func changePassword(oldPassword: String, newPassword: String, domain: String) async -> (Result<User_BaseResponse, Error>)
	
}

public class UserService {
	var byteV: UnsafePointer<CUnsignedChar>?
	var usr: OpaquePointer?
	var clientStore: ClientStore
	
	public init(clientStore: ClientStore) {
		self.clientStore = clientStore
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
	
	public func getListStatus(ids: [String], workspaceDomain: String, domain: String) async -> (Result<User_GetClientsStatusResponse, Error>) {
		var request = User_GetClientsStatusRequest()
		var client = User_MemberInfoRequest()
		let clients = ids.map { id -> User_MemberInfoRequest in
			var client = User_MemberInfoRequest()
			client.clientID = id
			client.workspaceDomain = workspaceDomain
			return client
		}
		request.lstClient = clients
		request.shouldGetProfile = true
		
		return await channelStorage.getChannel(domain: domain).getClientsStatus(request)
		
	}
	
	public func searchUserWithEmail(emailHash: String, domain: String) async -> (Result<User_FindUserByEmailResponse, Error>) {
		var request = User_FindUserByEmailRequest()
		request.emailHash = emailHash
		
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
		guard let server = channelStorage.realmManager.getServer(by: domain) else { return .failure(ServerError.unknown) }
		let srp = SwiftSRP.shared
		
		guard let aValue = srp.getA(userName: server.profile?.email ?? "", rawPassword: oldPassword, usr: &usr) else { return .failure(ServerError.unknown) }
		let aHex = bytesConvertToHexString(bytes: aValue)
		
		var request = User_RequestChangePasswordReq()
		request.clientPublic = aHex
		
		let response = await channelStorage.getChannel(domain: domain).requestChangePassword(request)
		
		switch response {
		case .success(let data):
			guard let mValue = await srp.getM(salt: data.salt.hexaBytes, byte: data.publicChallengeB.hexaBytes, usr: usr) else { return .failure(ServerError.unknown) }
			let mHex = bytesConvertToHexString(bytes: mValue)
			
			guard let salt = srp.getSalt(userName: server.profile?.email ?? "", rawPassword: newPassword, byteV: &byteV),
				  let verificator = srp.getVerificator(byteV: byteV) else { return(.failure(ServerError.unknown)) }
			let saltHex = bytesConvertToHexString(bytes: salt)
			let verificatorHex = bytesConvertToHexString(bytes: verificator)
			
			srp.freeMemoryAuthenticate(usr: &usr)
			
			let pbkdf2 = PBKDF2(passPharse: newPassword)
			
			let key = KeyHelper.generateIdentityKeyPair()
			let preKeys = KeyHelper.generatePreKeys(withStartingPreKeyId: 1, count: 1)
			guard let preKey = preKeys.first,
				  let signedPreKeyRecord = KeyHelper.generateSignedPreKeyRecord(withIdentity: key, signedPreKeyId: UInt32(bitPattern: (server.profile?.email ?? "" + domain).hashCode()))
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
			
			var request = User_ChangePasswordRequest()
			request.clientPublic = aHex
			request.clientSessionKeyProof = mHex
			request.hashPassword = verificatorHex
			request.salt = saltHex
			request.ivParameter = bytesConvertToHexString(bytes: pbkdf2.iv)
			request.identityKeyEncrypted = bytesConvertToHexString(bytes: encrypt ?? [])
			
			let response = await channelStorage.getChannel(domain: domain, accessToken: server.accessKey, hashKey: server.hashKey).changePassword(request)
			switch response {
			case .success(let data):
				return(.success(data))
			case .failure(let error):
				return(.failure(error))
			}
		case .failure(let error):
			return(.failure(error))
		}
	}
}

extension UserService {
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
