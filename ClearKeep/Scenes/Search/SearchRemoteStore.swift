//
//  SearchRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 05/04/2022.
//

import Foundation
import Combine
import ChatSecure
import Model
import Networking

protocol ISearchRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<ISearchModels, Error>
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	func getListStatus(domain: String, data: [[String: String]]) async -> Result<ISearchModels, Error>
	func searchUser(keyword: String, domain: String) async -> (Result<ISearchModels, Error>)
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [SearchGroupViewModel], domain: String) async -> (Result<ISearchModels, Error>)
}

struct SearchRemoteStore {
	let groupAPIService: IGroupService
	let userService: IUserService
	let messageService: IMessageService
}

extension SearchRemoteStore: ISearchRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<ISearchModels, Error> {
		let result = await groupAPIService.getJoinedGroups(domain: domain)
		
		switch result {
		case .success(let realmGroups):
			let groups = realmGroups.compactMap { group in
				GroupModel(group)
			}
			return .success(SearchModels(responseGroup: groups))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		let result = await messageService.getMessage(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, isGroup: isGroup, lastMessageAt: lastMessageAt)
		switch result {
		case .success(let realmMessage):
			print(realmMessage)
			return .success(realmMessage)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getListStatus(domain: String, data: [[String: String]]) async -> Result<ISearchModels, Error> {
		let result = await userService.getListStatus(data: data, domain: domain)
		switch result {
		case .success(let response):
			let client = response.lstClient.first(where: { $0.clientID == DependencyResolver.shared.channelStorage.currentServer?.profile?.userId })
			return .success(SearchModels(responseUser: client, members: response.lstClient))
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUser(keyword: String, domain: String) async -> (Result<ISearchModels, Error>) {
		let result = await userService.searchUser(keyword: keyword, domain: domain)
		switch result {
		case .success(let serchUser):
			return .success(SearchModels(searchUser: serchUser))
		case .failure(let error):
			return .failure(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [SearchGroupViewModel], domain: String) async -> (Result<ISearchModels, Error>) {

		var clientInGroups = [Group_ClientInGroupObject]()
		lstClient.forEach { data in
			var clientInGroup = Group_ClientInGroupObject()
			clientInGroup.id = data.userId
			clientInGroup.displayName = data.groupName
			clientInGroup.workspaceDomain = data.userDomain
			clientInGroups.append(clientInGroup)
		}

		let result = await groupAPIService.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: clientInGroups, domain: domain)

		switch result {
		case .success(let createdGroups):
			return .success(SearchModels(creatGroups: createdGroups))
		case .failure(let error):
			return .failure(error)
		}
	}
}
