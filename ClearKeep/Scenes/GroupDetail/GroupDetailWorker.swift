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

	func getGroup(by groupId: Int64) async -> (Result<IGroupDetaiModels, Error>)
	func addMember(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetaiModels, Error>)
	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetaiModels, Error>)
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
	func getGroup(by groupId: Int64) async -> (Result<IGroupDetaiModels, Error>) {
		let result = await remoteStore.getGroup(by: groupId, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func addMember(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetaiModels, Error>) {
		let result = await remoteStore.addMember(user, groupId: groupId, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func leaveGroup(_ user: GroupDetailClientViewModel, groupId: Int64) async -> (Result<IGroupDetaiModels, Error>) {
		let result = await remoteStore.leaveGroup(user, groupId: groupId, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
}
