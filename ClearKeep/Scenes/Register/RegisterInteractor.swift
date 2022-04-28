//
//  RegisterInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Common
import ChatSecure
import GRPC

protocol IRegisterInteractor {
	func register(displayName: String, email: String, password: String, domain: String) async
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

	func register(displayName: String, email: String, password: String, domain: String) async {
		await worker.register(displayName: displayName, email: email, password: password, domain: domain)
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

	func register(displayName: String, email: String, password: String, domain: String) async {
	}
}
