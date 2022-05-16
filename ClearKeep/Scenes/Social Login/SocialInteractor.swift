//
//  SocialInteractor.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Common
import ChatSecure
import Model

protocol ISocialInteractor {
	var worker: ISocialWorker { get }
	
	func registerSocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel>
	func verifySocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel>
}

class SocialInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	var appTokenService: IAppTokenService
	
	init(appState: Store<AppState>,
				  channelStorage: IChannelStorage,
				  authenticationService: IAuthenticationService,
				  appTokenService: IAppTokenService) {
		self.appState = appState
		self.channelStorage = channelStorage
		self.authenticationService = authenticationService
		self.appTokenService = appTokenService
	}
}

extension SocialInteractor: ISocialInteractor {
	var worker: ISocialWorker {
		let remoteStore = SocialRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = SocialInMemoryStore()
		return SocialWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func registerSocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		let result = await worker.registerSocialPin(userName: userName, rawPin: rawPin, customServer: customServer)
		
		switch result {
		case .success(let data):
			appTokenService.accessToken = data.normalLogin?.accessToken
			appState[\.authentication.accessToken] = appTokenService.accessToken
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
	func verifySocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		let result = await worker.verifySocialPin(userName: userName, rawPin: rawPin, customServer: customServer)
		
		switch result {
		case .success(let data):
			appTokenService.accessToken = data.normalLogin?.accessToken
			appState[\.authentication.accessToken] = appTokenService.accessToken
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubSocialInteractor: ISocialInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	
	var worker: ISocialWorker {
		let remoteStore = SocialRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = SocialInMemoryStore()
		return SocialWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func registerSocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		return .notRequested
	}
	
	func verifySocialPin(userName: String, rawPin: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		return .notRequested
	}
}
