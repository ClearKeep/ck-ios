//
//  UserService.swift
//  ChatSecure
//
//  Created by NamNH on 28/04/2022.
//

import Foundation
import Networking

public protocol IUserService {
	func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error>
	func getUsers(domain: String) async -> (Result<User_GetUsersResponse, Error>)
	func searchUser(keyword: String, domain: String) async -> (Result<User_SearchUserResponse, Error>)
	func getUserInfo(clientID: String, workspaceDomain: String, domain: String) async -> (Result<User_UserInfoResponse, Error>)
	func getListStatus(clientID: String, workspaceDomain: String, domain: String) async -> (Result<User_GetClientsStatusResponse, Error>)
	func searchUserWithEmail(emailHash: String, domain: String) async -> (Result<User_FindUserByEmailResponse, Error>)
	func pingRequest(domain: String) async -> Result<User_BaseResponse, Error>
	func updateStatus(status: String, domain: String) async -> Result<User_BaseResponse, Error>
	func uploadAvatar(fileName: String, fileContentType: String, fileData: Data, fileHash: String, domain: String) async -> (Result<User_UploadAvatarResponse, Error>)
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool, domain: String) async -> (Result<User_BaseResponse, Error>)
}

public class UserService {
	
	public init() {
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
    
    public func getListStatus(clientID: String, workspaceDomain: String, domain: String) async -> (Result<User_GetClientsStatusResponse, Error>) {
        var request = User_GetClientsStatusRequest()
        var client = User_MemberInfoRequest()
        client.clientID = clientID
        client.workspaceDomain = workspaceDomain
        request.lstClient = [client]
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
}
