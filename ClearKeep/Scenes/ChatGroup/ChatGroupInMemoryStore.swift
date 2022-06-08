//
//  ChatGroupInMemoryStore.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Combine
import ChatSecure
import Model
import Networking

protocol IChatGroupInMemoryStore {
	func getAddUser(domain: String) async -> (Result<IGroupChatModels, Error>)
	func addClient(user: CreatGroupGetUsersViewModel) -> [CreatGroupGetUsersViewModel]
	var clientsInGroup: [CreatGroupGetUsersViewModel] { get }
}

struct ChatGroupInMemoryStore {
	let groupService: IGroupService
	let userService: IUserService
	var clients = [CreatGroupGetUsersViewModel]()
}

extension ChatGroupInMemoryStore: IChatGroupInMemoryStore {
	func getAddUser(domain: String) async -> (Result<IGroupChatModels, Error>) {
		let result = await userService.getUsers(domain: domain)
		switch result {
		case .success(let getUser):
			return .success(GroupChatModels(getUser: getUser))
		case .failure(let error):
			return .failure(error)
		}
	}

	func addClient(user: CreatGroupGetUsersViewModel) -> [CreatGroupGetUsersViewModel] {
		var clientInGroup = clients
		clientInGroup.append(user)
		return clientInGroup
	}

	var clientsInGroup: [CreatGroupGetUsersViewModel] {
		return clients
	}
}
