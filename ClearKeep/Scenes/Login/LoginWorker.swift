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
	var currentServer: ServerModel? { get }
	var appVersion: String { get }
	
	func signIn(email: String, password: String, customServer: CustomServer) async -> Result<IAuthenticationModel, Error>
	func signInSocial(_ socialType: SocialType, customServer: CustomServer) async -> Result<IAuthenticationModel, Error>
	func emailValid(email: String) -> Bool
}

struct LoginWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ILoginRemoteStore
	let inMemoryStore: ILoginInMemoryStore
	let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")

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
	
	var currentServer: ServerModel? {
		ServerModel(channelStorage.currentServer)
	}
	
	var currentDomain: String {
		channelStorage.currentDomain
	}
	
	func signIn(email: String, password: String, customServer: CustomServer) async -> Result<IAuthenticationModel, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.signIn(email: email, password: password, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}
	
	func signInSocial(_ socialType: SocialType, customServer: CustomServer) async -> Result<IAuthenticationModel, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.signInSocial(socialType, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}

	func emailValid(email: String) -> Bool {
		let result = self.emailPredicate.evaluate(with: email)
		return result
	}
}
