//
//  LoginInteractor.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Common
import ChatSecure
import Model

protocol ILoginInteractor {
	func signIn(email: String, password: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel>
	func signInSocial(_ socialType: SocialType, customServer: CustomServer) async -> Loadable<IAuthenticationModel>
	func getAppVersion() -> String
}

class LoginInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
	var appTokenService: IAppTokenService
	
	init(appState: Store<AppState>,
		 channelStorage: IChannelStorage,
		 socialAuthenticationService: ISocialAuthenticationService,
		 authenticationService: IAuthenticationService,
		 appTokenService: IAppTokenService) {
		self.appState = appState
		self.channelStorage = channelStorage
		self.socialAuthenticationService = socialAuthenticationService
		self.authenticationService = authenticationService
		self.appTokenService = appTokenService
	}
}

extension LoginInteractor: ILoginInteractor {
	var worker: ILoginWorker {
		let remoteStore = LoginRemoteStore(socialAuthenticationService: socialAuthenticationService, authenticationService: authenticationService)
		let inMemoryStore = LoginInMemoryStore()
		return LoginWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func signIn(email: String, password: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		let result = await worker.signIn(email: email, password: password, customServer: customServer)
		
		switch result {
		case .success(let data):
			appTokenService.accessToken = data.normalLogin?.accessToken
			appState[\.authentication.accessToken] = appTokenService.accessToken
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func signInSocial(_ socialType: SocialType, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		let result = await worker.signInSocial(socialType, customServer: customServer)
		
		switch result {
		case .success(let data):
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func getAppVersion() -> String {
		return worker.appVersion
	}
}

struct StubLoginInteractor: ILoginInteractor {
	let channelStorage: IChannelStorage
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
	
	var worker: ILoginWorker {
		let remoteStore = LoginRemoteStore(socialAuthenticationService: socialAuthenticationService, authenticationService: authenticationService)
		let inMemoryStore = LoginInMemoryStore()
		return LoginWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func signIn(email: String, password: String, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		return .notRequested
	}
	
	func signInSocial(_ socialType: SocialType, customServer: CustomServer) async -> Loadable<IAuthenticationModel> {
		return .notRequested
	}
	
	func getAppVersion() -> String {
		return worker.appVersion
	}
}
