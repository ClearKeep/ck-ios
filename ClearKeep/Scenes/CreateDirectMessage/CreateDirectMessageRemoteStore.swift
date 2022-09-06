//
//  CreateDirectMessageRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import Combine
import ChatSecure
import Model
import Networking

protocol ICreateDirectMessageRemoteStore {
	func searchUser(keyword: String, domain: String) async -> (Result<ICreatePeerModels, Error>)
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel], domain: String) async -> (Result<ICreatePeerModels, Error>)
	func getProfile(domain: String) async -> Result<ICreatePeerModels, Error>
	func getUserProfile(clientId: String, workspaceDomain: String, domain: String) async -> Result<ICreatePeerModels, Error>
	func searchUserWithEmail(keyword: String, domain: String) async -> (Result<ICreatePeerModels, Error>)
	func getListStatus(domain: String, data: [[String: String]]) async -> Result<ICreatePeerModels, Error>
}

struct CreateDirectMessageRemoteStore {
	let groupService: IGroupService
	let userService: IUserService
	
	enum CreateDirectMessageError: Error {
		case searchLinkError
	}
}

extension CreateDirectMessageRemoteStore: ICreateDirectMessageRemoteStore {
	func searchUser(keyword: String, domain: String) async -> (Result<ICreatePeerModels, Error>) {
		let result = await userService.searchUser(keyword: keyword, domain: domain)
		switch result {
		case .success(let serchUser):
			return .success(CreatePeerModels(searchUser: serchUser))
		case .failure(let error):
			return .failure(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel], domain: String) async -> (Result<ICreatePeerModels, Error>) {

		var clientInGroups = [Group_ClientInGroupObject]()
		lstClient.forEach { users in
			var clientInGroup = Group_ClientInGroupObject()
			clientInGroup.id = users.id
			clientInGroup.displayName = users.displayName
			clientInGroup.workspaceDomain = users.workspaceDomain
			clientInGroups.append(clientInGroup)
		}

		let result = await groupService.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: clientInGroups, domain: domain)

		switch result {
		case .success(let createdGroups):
			return .success(CreatePeerModels(creatGroups: createdGroups))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getProfile(domain: String) async -> Result<ICreatePeerModels, Error> {
		let result = await userService.getProfile(domain: domain)

		switch result {
		case .success(let user):
			return .success(CreatePeerModels(getProfile: user))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getUserProfile(clientId: String, workspaceDomain: String, domain: String) async -> Result<ICreatePeerModels, Error> {
		let result = await userService.getUserInfo(clientID: clientId, workspaceDomain: workspaceDomain, domain: domain)
		switch result {
		case .success(let user):
			return .success(CreatePeerModels(userProfileWithLink: user))
		case .failure:
			return .failure(CreateDirectMessageError.searchLinkError)
		}
	}
	
	func searchUserWithEmail(keyword: String, domain: String) async -> (Result<ICreatePeerModels, Error>) {
		let result = await userService.searchUserWithEmail(email: keyword, domain: domain)
		switch result {
		case .success(let user):
			return .success(CreatePeerModels(searchUserWithEmail: user))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getListStatus(domain: String, data: [[String: String]]) async -> Result<ICreatePeerModels, Error> {
		let result = await userService.getListStatus(data: data, domain: domain)
		switch result {
		case .success(let response):
			let client = response.lstClient.first(where: { $0.clientID == DependencyResolver.shared.channelStorage.currentServer?.profile?.userId })
			return .success(CreatePeerModels(responseUser: client, members: response.lstClient))
		case .failure(let error):
			return .failure(error)
		}
	}
}
