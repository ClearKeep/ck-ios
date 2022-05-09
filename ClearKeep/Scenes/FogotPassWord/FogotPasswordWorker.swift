//
//  FogotPasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Combine
import Common
import ChatSecure

protocol IFogotPasswordWorker {
	var remoteStore: IFogotPasswordRemoteStore { get }
	var inMemoryStore: IFogotPasswordInMemoryStore { get }

	func recoverPassword(email: String, customServer: CustomServer) async -> Result<Bool, Error>
}

struct FogotPasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IFogotPasswordRemoteStore
	let inMemoryStore: IFogotPasswordInMemoryStore
	
	init(channelStorage: IChannelStorage,
		 remoteStore: IFogotPasswordRemoteStore,
		 inMemoryStore: IFogotPasswordInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension FogotPasswordWorker: IFogotPasswordWorker {
	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
	
	func recoverPassword(email: String, customServer: CustomServer) async -> Result<Bool, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.recoverPassword(email: email, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}
}
