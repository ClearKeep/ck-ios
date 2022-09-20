//
//  NewPasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import GRPC
import Model

protocol INewPasswordInteractor {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
	func getServers() -> [RealmServer]
}

struct NewPasswordInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension NewPasswordInteractor: INewPasswordInteractor {
	
	var worker: INewPasswordWorker {
		let remoteStore = NewPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = NewPasswordInMemoryStore()
		return NewPasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		let result = await worker.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
		switch result {
		case .success(let data):
			return .success(data)
		case .failure(let error):
			return .failure(error)
		}
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
	
	func getServers() -> [RealmServer] {
		return self.channelStorage.getServers(isFirstLoad: false)
	}
}

struct StubNewPasswordInteractor: INewPasswordInteractor {
	let authenticationService: IAuthenticationService
	let channelStorage: IChannelStorage
	
	
	var worker: INewPasswordWorker {
		let remoteStore = NewPasswordRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = NewPasswordInMemoryStore()
		return NewPasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error> {
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
	
	func getServers() -> [RealmServer] {
		return self.channelStorage.servers
	}
}
