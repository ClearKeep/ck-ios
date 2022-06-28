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
	func registerToken(_ token: Data)
	func subscribeAndListenServers()
	func getJoinedGroup() async -> Result<IHomeModels, Error>
	func didSelectServer(_ domain: String?) -> [ServerModel]
	func getProfile() async -> Result<IHomeModels, Error>
	func signOut() async -> Bool
	func refreshToken() async -> Bool
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
	
	func registerToken(_ token: Data) {
		let tokenParts = token.map { data in String(format: "%02.2hhx", data) }
		let tokenString = tokenParts.joined()
		print("Device Token: \(tokenString)")
		
		channelStorage.registerToken(tokenString)
	}
	
	func subscribeAndListenServers() {
		self.servers.forEach { server in
			remoteStore.subscribeAndListenServers(domain: server.serverDomain)
		}
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
	
	func signOut() async -> Bool {
		let result = await remoteStore.signOut(domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let data):
			print(data)
			return true
		case .failure(let error):
			print(error)
			return false
		}
	}
	
	func refreshToken() async -> Bool {
		let domain = currentDomain ?? channelStorage.currentDomain
		let result = await remoteStore.refreshToken(domain: domain)
		
		switch result {
		case .success(let token):
			channelStorage.updateServerToken(token: token, domain: domain)
			return true
		case .failure(let error):
			print(error)
			return false
		}
	}
}
