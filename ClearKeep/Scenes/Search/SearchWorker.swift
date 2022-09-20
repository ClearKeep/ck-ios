//
//  SearchWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 05/04/2022.
//

import Networking
import Model
import Common
import RealmSwift
import ChatSecure

protocol ISearchWorker {
	var remoteStore: ISearchRemoteStore { get }
	var inMemoryStore: ISearchInMemoryStore { get }
	func getJoinedGroup() async -> Result<ISearchModels, Error>
	func getMessageList(groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	func getListStatus(data: [[String: String]]) async -> Result<ISearchModels, Error>
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>?
	func searchUser(keyword: String) async -> (Result<ISearchModels, Error>)
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [SearchGroupViewModel]) async -> (Result<ISearchModels, Error>)
}

struct SearchWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ISearchRemoteStore
	let inMemoryStore: ISearchInMemoryStore
	var currentDomain: String?
	
	init(channelStorage: IChannelStorage,
		 remoteStore: ISearchRemoteStore,
		 inMemoryStore: ISearchInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SearchWorker: ISearchWorker {
	func getJoinedGroup() async -> Result<ISearchModels, Error> {
		return await remoteStore.getJoinedGroup(domain: currentDomain ?? channelStorage.currentDomain)
	}
	
	func getMessageList(groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return .failure(ServerError.unknown) }
		let ownerDomain = server.serverDomain
		let result = await remoteStore.getMessageList(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, isGroup: isGroup, lastMessageAt: lastMessageAt)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getListStatus(data: [[String: String]]) async -> Result<ISearchModels, Error> {
		let result = await remoteStore.getListStatus(domain: self.channelStorage.currentDomain, data: data)
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>? {
		return inMemoryStore.getMessageFromLocal(groupId: groupId, ownerDomain: ownerDomain, ownerId: ownerId)
	}

	func searchUser(keyword: String) async -> (Result<ISearchModels, Error>) {
		let result = await remoteStore.searchUser(keyword: keyword, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [SearchGroupViewModel]) async -> (Result<ISearchModels, Error>) {
		return await remoteStore.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient, domain: currentDomain ?? channelStorage.currentDomain)
	}
}
