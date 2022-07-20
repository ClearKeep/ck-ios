//
//  GroupDetailRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model
import Networking

protocol IGroupDetailRemoteStore {
	func getGroup(by groupId: Int64, domain: String) async -> (Result<IGroupDetailModels, Error>)
	func searchUser(keyword: String, domain: String) async -> (Result<IGroupDetailModels, Error>)
	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64, domain: String) async -> (Result<IGroupDetailModels, Error>)
	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64, domain: String) async -> (Result<IGroupDetailModels, Error>)
	func getProfile(domain: String) async -> Result<IGroupDetailModels, Error>
	func getUserProfile(clientId: String, workspaceDomain: String, domain: String) async -> Result<IGroupDetailModels, Error>
	func searchUserWithEmail(keyword: String, domain: String) async -> (Result<IGroupDetailModels, Error>)
}

struct GroupDetailRemoteStore {
	let groupService: IGroupService
	let userService: IUserService
}

extension GroupDetailRemoteStore: IGroupDetailRemoteStore {
	func getGroup(by groupId: Int64, domain: String) async -> (Result<IGroupDetailModels, Error>) {
		let result = await groupService.getGroup(by: groupId, domain: domain)
		switch result {
		case .success(let realmGroups):
			return .success(GroupDetailModels(responseGroup: GroupModel(realmGroups)))
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUser(keyword: String, domain: String) async -> (Result<IGroupDetailModels, Error>) {
		let result = await userService.searchUser(keyword: keyword, domain: domain)
		switch result {
		case .success(let serchUser):
			return .success(GroupDetailModels(searchUser: serchUser))
		case .failure(let error):
			return .failure(error)
		}
	}

	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64, domain: String) async -> (Result<IGroupDetailModels, Error>) {
		var client = Group_ClientInGroupObject()
		client.id = user.id
		client.displayName = user.displayName
		client.workspaceDomain = user.workspaceDomain

		let result = await groupService.addMember(client, groupId: groupId, domain: domain)

		switch result {
		case .success(let addMember):
			return .success(GroupDetailModels(responseError: addMember))
		case .failure(let error):
			return .failure(error)
		}
	}

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64, domain: String) async -> (Result<IGroupDetailModels, Error>) {
		var client = Group_ClientInGroupObject()
		client.id = user.id
		client.displayName = user.userName
		client.workspaceDomain = user.domain
		let result = await groupService.leaveGroup(client, groupId: groupId, domain: domain)

		switch result {
		case .success(let leaveGroup):
			return .success(GroupDetailModels(responseError: leaveGroup))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getProfile(domain: String) async -> Result<IGroupDetailModels, Error> {
		let result = await userService.getProfile(domain: domain)

		switch result {
		case .success(let user):
			return .success(GroupDetailModels(getProfile: user))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getUserProfile(clientId: String, workspaceDomain: String, domain: String) async -> Result<IGroupDetailModels, Error> {
		let result = await userService.getUserInfo(clientID: clientId, workspaceDomain: workspaceDomain, domain: domain)
		switch result {
		case .success(let user):
			return .success(GroupDetailModels(userProfileWithLink: user))
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUserWithEmail(keyword: String, domain: String) async -> (Result<IGroupDetailModels, Error>) {
		let result = await userService.searchUserWithEmail(emailHash: keyword.sha256(), domain: domain)
		switch result {
		case .success(let user):
			return .success(GroupDetailModels(searchUserWithEmail: user))
		case .failure(let error):
			return .failure(error)
		}
	}
}
