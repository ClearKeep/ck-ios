//
//  ChatGroupWorker.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Foundation
import Model
import ChatSecure
import SwiftUI

protocol IChatGroupWorker {
	var remoteStore: IChatGroupRemoteStore { get }
	var inMemoryStore: IChatGroupInMemoryStore { get }

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> (Result<IGroupChatModels, Error>)
	func searchUser(keyword: String) async -> (Result<IGroupChatModels, Error>)
	func getProfile() async -> Result<IGroupChatModels, Error>
}

struct ChatGroupWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IChatGroupRemoteStore
	let inMemoryStore: IChatGroupInMemoryStore
	var currentDomain: String?

	init(channelStorage: IChannelStorage,
		 remoteStore: IChatGroupRemoteStore,
		 inMemoryStore: IChatGroupInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChatGroupWorker: IChatGroupWorker {

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatGroupGetUsersViewModel]) async -> (Result<IGroupChatModels, Error>) {
		return await remoteStore.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient, domain: currentDomain ?? channelStorage.currentDomain)
	}

	func searchUser(keyword: String) async -> (Result<IGroupChatModels, Error>) {
		let result = await remoteStore.searchUser(keyword: keyword, domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func getProfile() async -> Result<IGroupChatModels, Error> {
		let result = await remoteStore.getProfile(domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

}
