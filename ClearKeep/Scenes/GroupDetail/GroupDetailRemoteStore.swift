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
	func getGroup(by groupId: Int64, domain: String) async -> (Result<IGroupDetaiModels, Error>)
	func addMember(_ user: GroupDetailClientViewModel, groupId: Int64, domain: String) async -> (Result<IGroupDetaiModels, Error>)
	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64, domain: String) async -> (Result<IGroupDetaiModels, Error>)

}

struct GroupDetailRemoteStore {
	let groupService: IGroupService
}

extension GroupDetailRemoteStore: IGroupDetailRemoteStore {
	func getGroup(by groupId: Int64, domain: String) async -> (Result<IGroupDetaiModels, Error>) {
		let result = await groupService.getJoinedGroups(domain: domain)

		switch result {
		case .success(let realmGroups):
			let groups = realmGroups.compactMap { group in
				GroupModel(group)
			}
			return .success(GroupDetaiModels(responseGroup: groups))
		case .failure(let error):
			return .failure(error)
		}
	}

	func addMember(_ user: GroupDetailClientViewModel, groupId: Int64, domain: String) async -> (Result<IGroupDetaiModels, Error>) {
		var client = Group_ClientInGroupObject()
		client.id = user.id
		client.displayName = user.displayName
		client.workspaceDomain = user.workspaceDomain

		let result = await groupService.addMember(client, groupId: groupId, domain: domain)

		switch result {
		case .success(let addMember):
			return .success(GroupDetaiModels(responseError: addMember))
		case .failure(let error):
			return .failure(error)
		}
	}

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64, domain: String) async -> (Result<IGroupDetaiModels, Error>) {
		var client = Group_ClientInGroupObject()
		client.id = user.id
		client.displayName = user.displayName
		client.workspaceDomain = user.workspaceDomain

		let result = await groupService.addMember(client, groupId: groupId, domain: domain)

		switch result {
		case .success(let leaveGroup):
			return .success(GroupDetaiModels(responseError: leaveGroup))
		case .failure(let error):
			return .failure(error)
		}
	}
}
