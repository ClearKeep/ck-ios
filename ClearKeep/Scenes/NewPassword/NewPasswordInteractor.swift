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
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
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

struct StubNewPasswordInteractor: INewPasswordInteractor {
	let authenticationService: IAuthenticationService

	var worker: INewPasswordWorker {
		let remoteStore = NewPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = NewPasswordInMemoryStore()
		return NewPasswordWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
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
