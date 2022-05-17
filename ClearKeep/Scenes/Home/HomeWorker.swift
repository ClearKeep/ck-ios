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
	var servers: [IServerModel] { get }
	
	func getJoinedGroup() async -> Result<[IGroupModel], Error>
	func signOut() async
}

struct HomeWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IHomeRemoteStore
	let inMemoryStore: IHomeInMemoryStore
	
	init(channelStorage: IChannelStorage, remoteStore: IHomeRemoteStore, inMemoryStore: IHomeInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension HomeWorker: IHomeWorker {
	var servers: [IServerModel] {
		channelStorage.getServers().compactMap({
			ServerModel($0)
		})
	}
	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
	
	func getJoinedGroup() async -> Result<[IGroupModel], Error> {
		return await remoteStore.getJoinedGroup(domain: currentDomain)
	}
	
	func signOut() async {
		await remoteStore.signOut()
	}
}
