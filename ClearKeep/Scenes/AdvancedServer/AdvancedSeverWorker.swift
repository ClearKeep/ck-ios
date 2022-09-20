//
//  AdvancedSeverWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import Model

protocol IAdvancedSeverWorker {
	var remoteStore: IAdvancedSeverRemoteStore { get }
	var inMemoryStore: IAdvancedSeverInMemoryStore { get }
	func workspaceInfo(workspaceDomain: String) async -> Result<Bool, Error>
}

struct AdvancedSeverWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IAdvancedSeverRemoteStore
	let inMemoryStore: IAdvancedSeverInMemoryStore
	
	init(channelStorage: IChannelStorage,
		 remoteStore: IAdvancedSeverRemoteStore,
		 inMemoryStore: IAdvancedSeverInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension AdvancedSeverWorker: IAdvancedSeverWorker {
	func workspaceInfo(workspaceDomain: String) async -> Result<Bool, Error> {
		await remoteStore.workspaceInfo(workspaceDomain: workspaceDomain)
	}
}
