//
//  GroupDetailWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import Foundation
import Model
import ChatSecure
import SwiftUI

protocol IGroupDetailWorker {
	var remoteStore: IGroupDetailRemoteStore { get }
	var inMemoryStore: IGroupDetailInMemoryStore { get }

	func getGroup(by groupId: Int64) async -> (Result<IGroupDetailModels, Error>)
	func searchUser(keyword: String) async -> (Result<IGroupDetailModels, Error>)
	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> (Result<IGroupDetailModels, Error>)
	func leaveGroup(_ user: GroupDetailProfileViewModel, groupId: Int64) async -> (Result<IGroupDetailModels, Error>)
	func getUserInfor(clientId: String, workspaceDomain: String) async -> (Result<IGroupDetailModels, Error>)
	func searchUserWithEmail(email: String) async -> (Result<IGroupDetailModels, Error>)
	func checkPeopleLink(link: String) -> Bool
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)?
	func getListStatus(data: [[String: String]]) async -> Result<IGroupDetailModels, Error>
}

struct GroupDetailWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IGroupDetailRemoteStore
	let inMemoryStore: IGroupDetailInMemoryStore
	var currentDomain: String?

	init(channelStorage: IChannelStorage,
		 remoteStore: IGroupDetailRemoteStore,
		 inMemoryStore: IGroupDetailInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension GroupDetailWorker: IGroupDetailWorker {
	func getGroup(by groupId: Int64) async -> (Result<IGroupDetailModels, Error>) {
		let result = await remoteStore.getGroup(by: groupId, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUser(keyword: String) async -> (Result<IGroupDetailModels, Error>) {
		let result = await remoteStore.searchUser(keyword: keyword, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func addMember(_ user: GroupDetailUserViewModels, groupId: Int64) async -> (Result<IGroupDetailModels, Error>) {
		let result = await remoteStore.addMember(user, groupId: groupId, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func leaveGroup(_ user: GroupDetailProfileViewModel, groupId: Int64) async -> (Result<IGroupDetailModels, Error>) {
		let result = await remoteStore.leaveGroup(user, groupId: groupId, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func getUserInfor(clientId: String, workspaceDomain: String) async -> (Result<IGroupDetailModels, Error>) {
		let result = await remoteStore.getUserProfile(clientId: clientId, workspaceDomain: workspaceDomain, domain: currentDomain ?? channelStorage.currentDomain)
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func searchUserWithEmail(email: String) async -> (Result<IGroupDetailModels, Error>) {
		let result = await remoteStore.searchUserWithEmail(keyword: email, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		let args = link.split(separator: "/")
		if args.count != 3 {
			return nil
		}

		return (String(args[2]), String(args[1]), String(args[0]))
	}

	func checkPeopleLink(link: String) -> Bool {
		return self.getPeopleFromLink(link: link)?.id == channelStorage.currentServer?.profile?.userId
	}

	func getListStatus(data: [[String: String]]) async -> Result<IGroupDetailModels, Error> {
		let result = await remoteStore.getListStatus(domain: self.channelStorage.currentDomain, data: data)
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
}
