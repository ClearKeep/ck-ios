//
//  RegisterInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Common
import ChatSecure

protocol IRegisterInteractor {
	func register(displayName: String, email: String, password: String, customServer: CustomServer) async -> Loadable<Bool>
}

struct RegisterInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension RegisterInteractor: IRegisterInteractor {
	var worker: IRegisterWorker {
		let remoteStore = RegisterRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = RegisterInMemoryStore()
		return RegisterWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func register(displayName: String, email: String, password: String, customServer: CustomServer) async -> Loadable<Bool> {
		let result = await worker.register(displayName: displayName, email: email, password: password, customServer: customServer)
		
		switch result {
		case .success(let data):
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubRegisterInteractor: IRegisterInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService

	var worker: IRegisterWorker {
		let remoteStore = RegisterRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = RegisterInMemoryStore()
		return RegisterWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func register(displayName: String, email: String, password: String, customServer: CustomServer) async -> Loadable<Bool> {
		return .notRequested
	}
}
