//
//  SocialWorker.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Combine
import Common
import ChatSecure
import Model

protocol ISocialWorker {
	var remoteStore: ISocialRemoteStore { get }
	var inMemoryStore: ISocialInMemoryStore { get }
	
	func registerSocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Result<IAuthenticationModel, Error>
	func verifySocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Result<IAuthenticationModel, Error>
}

struct SocialWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ISocialRemoteStore
	let inMemoryStore: ISocialInMemoryStore

	init(channelStorage: IChannelStorage,
		 remoteStore: ISocialRemoteStore,
		 inMemoryStore: ISocialInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SocialWorker: ISocialWorker {
	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
	
	func registerSocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Result<IAuthenticationModel, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.registerSocialPin(rawPin: rawPin, userId: userName, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}
	
	func verifySocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Result<IAuthenticationModel, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.verifySocialPin(rawPin: rawPin, userId: userName, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}
}
