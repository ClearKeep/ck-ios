//
//  CreateDirectMessageWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import Foundation
import Model
import ChatSecure

protocol ICreateDirectMessageWorker {
	var remoteStore: ICreateDirectMessageRemoteStore { get }
	var inMemoryStore: ICreateDirectMessageInMemoryStore { get }

	func searchUser(keyword: String) async -> (Result<ICreatePeerModels, Error>)
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> (Result<ICreatePeerModels, Error>)
	func getProfile() async -> Result<ICreatePeerModels, Error>
}

struct CreateDirectMessageWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ICreateDirectMessageRemoteStore
	let inMemoryStore: ICreateDirectMessageInMemoryStore
	var currentDomain: String?

	init(channelStorage: IChannelStorage,
		 remoteStore: ICreateDirectMessageRemoteStore,
		 inMemoryStore: ICreateDirectMessageInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension CreateDirectMessageWorker: ICreateDirectMessageWorker {
	func searchUser(keyword: String) async -> (Result<ICreatePeerModels, Error>) {
		let result = await remoteStore.searchUser(keyword: keyword, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> (Result<ICreatePeerModels, Error>) {
		return await remoteStore.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient, domain: currentDomain ?? channelStorage.currentDomain)
	}

	func getProfile() async -> Result<ICreatePeerModels, Error> {
		let result = await remoteStore.getProfile(domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

}
