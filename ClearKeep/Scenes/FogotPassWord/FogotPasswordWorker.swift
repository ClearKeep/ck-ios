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
	func emailValid(email: String) -> Bool
}

struct FogotPasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IFogotPasswordRemoteStore
	let inMemoryStore: IFogotPasswordInMemoryStore
	let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")

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
		channelStorage.currentDomain
	}
	
	func recoverPassword(email: String, customServer: CustomServer) async -> Result<Bool, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.recoverPassword(email: email, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}

	func emailValid(email: String) -> Bool {
		let result = self.emailPredicate.evaluate(with: email)
		return result
	}
}
