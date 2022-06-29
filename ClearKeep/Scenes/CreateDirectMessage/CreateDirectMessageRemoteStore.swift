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
}

struct CreateDirectMessageRemoteStore {
	let groupService: IGroupService
	let userService: IUserService
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
}
