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
	func searchGroups(_ keyword: String, domain: String) async -> (Result<ISearchModels, Error>)
	func searchUser(_ keyword: String, domain: String) async -> (Result<ISearchModels, Error>)
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
}

struct SearchRemoteStore {
	let groupAPIService: IGroupService
	let userService: IUserService
	let messageService: IMessageService
}

extension SearchRemoteStore: ISearchRemoteStore {
	func searchGroups(_ keyword: String, domain: String) async -> (Result<ISearchModels, Error>) {
		let result = await groupAPIService.searchGroups(keyword, domain: domain)

		switch result {
		case .success(let searchResponse):
			return .success(SearchModels(searchGroup: searchResponse))
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUser(_ keyword: String, domain: String) async -> (Result<ISearchModels, Error>) {
		let result = await userService.searchUser(keyword: keyword, domain: domain)

		switch result {
		case .success(let searchResponse):
			return .success(SearchModels(searchUser: searchResponse))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		let result = await messageService.getMessage(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, lastMessageAt: lastMessageAt)
		switch result {
		case .success(let realmMessage):
			print(realmMessage)
			return .success(realmMessage)
		case .failure(let error):
			return .failure(error)
		}
	}

}
