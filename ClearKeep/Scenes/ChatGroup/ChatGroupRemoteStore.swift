//
//  ChatGroupRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Combine
import ChatSecure
import Model
import Networking

protocol IChatGroupRemoteStore {
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel], domain: String) async -> (Result<IGroupChatModels, Error>)
	func searchUser(keyword: String, domain: String) async -> (Result<IGroupChatModels, Error>)
	func getProfile(domain: String) async -> Result<IGroupChatModels, Error>
	func getUserProfile(clientId: String, workspaceDomain: String, domain: String) async -> Result<IGroupChatModels, Error>
	func searchUserWithEmail(keyword: String, domain: String) async -> (Result<IGroupChatModels, Error>)
}

struct ChatGroupRemoteStore {
	let groupService: IGroupService
	let userService: IUserService
}

extension ChatGroupRemoteStore: IChatGroupRemoteStore {
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel], domain: String) async -> (Result<IGroupChatModels, Error>) {

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
			return .success(GroupChatModels(creatGroups: createdGroups))
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUser(keyword: String, domain: String) async -> (Result<IGroupChatModels, Error>) {
		let result = await userService.searchUser(keyword: keyword, domain: domain)
		switch result {
		case .success(let serchUser):
			return .success(GroupChatModels(searchUser: serchUser))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getProfile(domain: String) async -> Result<IGroupChatModels, Error> {
		let result = await userService.getProfile(domain: domain)

		switch result {
		case .success(let user):
			return .success(GroupChatModels(getProfile: user))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getUserProfile(clientId: String, workspaceDomain: String, domain: String) async -> Result<IGroupChatModels, Error> {
		let result = await userService.getUserInfo(clientID: clientId, workspaceDomain: workspaceDomain, domain: domain)
		switch result {
		case .success(let user):
			return .success(GroupChatModels(userProfileWithLink: user))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func searchUserWithEmail(keyword: String, domain: String) async -> (Result<IGroupChatModels, Error>) {
		let result = await userService.searchUserWithEmail(emailHash: keyword.sha256(), domain: domain)
		switch result {
		case .success(let user):
			return .success(GroupChatModels(searchUserWithEmail: user))
		case .failure(let error):
			return .failure(error)
		}
	}
	
}
