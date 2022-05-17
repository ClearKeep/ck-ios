//
//  FogotPasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import GRPC

protocol IFogotPasswordInteractor {
	func recoverPassword(email: String, customServer: CustomServer) async -> Loadable<Bool>
	func emailValid(email: String) -> Bool
}

struct FogotPasswordInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension FogotPasswordInteractor: IFogotPasswordInteractor {
	var worker: IFogotPasswordWorker {
		let remoteStore = FogotPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = FogotPasswordInMemoryStore()
		return FogotPasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func recoverPassword(email: String, customServer: CustomServer) async -> Loadable<Bool> {
		let result = await worker.recoverPassword(email: email, customServer: customServer)
		
		switch result {
		case .success(let data):
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}

	func emailValid(email: String) -> Bool {
		return worker.emailValid(email: email)
	}
}

struct StubFogotPasswordInteractor: IFogotPasswordInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService

	var worker: IFogotPasswordWorker {
		let remoteStore = FogotPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = FogotPasswordInMemoryStore()
		return FogotPasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func recoverPassword(email: String, customServer: CustomServer) async -> Loadable<Bool> {
		return .notRequested
	}

	func emailValid(email: String) -> Bool {
		return worker.emailValid(email: email)
	}
}
