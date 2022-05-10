//
//  NewPasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import GRPC

protocol INewPasswordInteractor {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
}

struct NewPasswordInteractor {
	let appState: Store<AppState>
	let authenticationService: IAuthenticationService
}

extension NewPasswordInteractor: INewPasswordInteractor {
	var worker: INewPasswordWorker {
		let remoteStore = NewPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = NewPasswordInMemoryStore()
		return NewPasswordWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
		await worker.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
	}
}

struct StubNewPasswordInteractor: INewPasswordInteractor {
	let authenticationService: IAuthenticationService

	var worker: INewPasswordWorker {
		let remoteStore = NewPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = NewPasswordInMemoryStore()
		return NewPasswordWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
	}
}
