//
//  LoginInteractor.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Common
import ChatSecure
import GRPC

protocol ILoginInteractor {
	func signIn(email: String, password: String) async -> Loadable<ILoginModel>
	func signInSocial(_ socialType: SocialType)
	func getAppVersion() -> String
}

struct LoginInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
}

extension LoginInteractor: ILoginInteractor {
	var worker: ILoginWorker {
		let remoteStore = LoginRemoteStore(socialAuthenticationService: socialAuthenticationService, authenticationService: authenticationService)
		let inMemoryStore = LoginInMemoryStore()
		return LoginWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func signIn(email: String, password: String) async -> Loadable<ILoginModel> {
		let result = await worker.signIn(email: email, password: password)
		
		switch result {
		case .success(let data):
			return .loaded(LoginModel(id: 1, email: "", password: ""))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func signInSocial(_ socialType: SocialType) {
		worker.signInSocial(socialType)
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
	
	func signIn(email: String, password: String) async -> Loadable<ILoginModel> {
		return .notRequested
	}
	
	func signInSocial(_ socialType: SocialType) {
		worker.signInSocial(socialType)
	}
	
	func getAppVersion() -> String {
		return worker.appVersion
	}
}
