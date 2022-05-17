//
//  ChangePasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import Model

protocol IChangePasswordInteractor {
	var worker: IChangePasswordWorker { get }
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
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

	func passwordValid(password: String) -> Bool {
		return worker.passwordValid(password: password)
	}

	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return worker.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
	}

	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		return worker.checkValid(passwordValdid: passwordValdid, confirmPasswordValid: confirmPasswordValid)
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

	func passwordValid(password: String) -> Bool {
		return worker.passwordValid(password: password)
	}

	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return worker.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
	}

	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		return worker.checkValid(passwordValdid: passwordValdid, confirmPasswordValid: confirmPasswordValid)
	}
}
