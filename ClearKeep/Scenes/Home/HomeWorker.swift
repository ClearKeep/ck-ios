//
//  HomeWorker.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Common
import ChatSecure
import Model

protocol IHomeWorker {
	var remoteStore: IHomeRemoteStore { get }
	var inMemoryStore: IHomeInMemoryStore { get }
	var servers: [ServerModel] { get }
	
	func validateDomain(_ domain: String) -> Bool
	func getJoinedGroup() async -> Result<IHomeModels, Error>
	func didSelectServer(_ domain: String?) -> [ServerModel]
	func getProfile() async -> Result<IHomeModels, Error>
	func signOut() async
}

class HomeWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IHomeRemoteStore
	let inMemoryStore: IHomeInMemoryStore
	var currentDomain: String?
	
	init(channelStorage: IChannelStorage, remoteStore: IHomeRemoteStore, inMemoryStore: IHomeInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension HomeWorker: IHomeWorker {
	var servers: [ServerModel] {
		channelStorage.getServers().compactMap({
			ServerModel($0)
		})
	}
	
	func validateDomain(_ domain: String) -> Bool {
		return !domain.isEmpty
	}
	
	func getJoinedGroup() async -> Result<IHomeModels, Error> {
		return await remoteStore.getJoinedGroup(domain: currentDomain ?? channelStorage.currentDomain)
	}
	
	func didSelectServer(_ domain: String?) -> [ServerModel] {
		currentDomain = domain
		return channelStorage.didSelectServer(domain).compactMap({
			ServerModel($0)
		})
	}
	
	func getProfile() async -> Result<IHomeModels, Error> {
		let result = await remoteStore.getProfile(domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signOut() async {
		await remoteStore.signOut()
	}
}
