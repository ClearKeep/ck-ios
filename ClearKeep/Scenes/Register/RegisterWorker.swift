//
//  RegisterWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Combine
import Common
import ChatSecure

protocol IRegisterWorker {
	var remoteStore: IRegisterRemoteStore { get }
	var inMemoryStore: IRegisterInMemoryStore { get }

	func register(displayName: String, email: String, password: String) async -> Result<Bool, Error>
}

struct RegisterWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IRegisterRemoteStore
	let inMemoryStore: IRegisterInMemoryStore

	init(channelStorage: IChannelStorage,
		remoteStore: IRegisterRemoteStore,
		 inMemoryStore: IRegisterInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension RegisterWorker: IRegisterWorker {
	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
	
	func register(displayName: String, email: String, password: String) async -> Result<Bool, Error> {
		return await remoteStore.register(displayName: displayName, email: email, password: password, domain: currentDomain)
	}
}
