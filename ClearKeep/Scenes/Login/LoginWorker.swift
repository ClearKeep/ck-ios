//
//  LoginWorker.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Combine
import Common
import ChatSecure
import Model

protocol ILoginWorker {
	var remoteStore: ILoginRemoteStore { get }
	var inMemoryStore: ILoginInMemoryStore { get }
	var currentDomain: String { get }
	var appVersion: String { get }
	
	func signIn(email: String, password: String) async -> Result<IAuthenticationModel, Error>
	func signInSocial(_ socialType: SocialType)
}

struct LoginWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ILoginRemoteStore
	let inMemoryStore: ILoginInMemoryStore

	init(channelStorage: IChannelStorage, remoteStore: ILoginRemoteStore, inMemoryStore: ILoginInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension LoginWorker: ILoginWorker {
	var appVersion: String {
		String(format: "General.Version".localized, AppVersion.getVersion())
	}
	
	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
	
	func signIn(email: String, password: String) async -> Result<IAuthenticationModel, Error> {
		return await remoteStore.signIn(email: email, password: password, domain: currentDomain)
	}
	
	func signInSocial(_ socialType: SocialType) {
		remoteStore.signInSocial(socialType, domain: currentDomain)
	}
}
