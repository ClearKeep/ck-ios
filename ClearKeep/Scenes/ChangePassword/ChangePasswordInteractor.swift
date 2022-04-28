//
//  ChangePasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import GRPC

protocol IChangePasswordInteractor {
	var worker: IChangePasswordWorker { get }
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
}

struct ChangePasswordInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension ChangePasswordInteractor: IChangePasswordInteractor {

	var worker: IChangePasswordWorker {
		let remoteStore = ChangePasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = ChangePasswordInMemoryStore()
		return ChangePasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
		await worker.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
	}
}

struct StubChangePasswordInteractor: IChangePasswordInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService

	var worker: IChangePasswordWorker {
		let remoteStore = ChangePasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = ChangePasswordInMemoryStore()
		return ChangePasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
	}

}
