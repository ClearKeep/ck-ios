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
	func recoverPassword(email: String, customServer: CustomServer) async
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

	func recoverPassword(email: String, customServer: CustomServer) async {
		await worker.recoverPassword(email: email, customServer: customServer)
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

	func recoverPassword(email: String, customServer: CustomServer) async {
	}
}
