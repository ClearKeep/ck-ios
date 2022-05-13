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
	func emailValid(email: String) -> Bool
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(emailValid: Bool, passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
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

	func emailValid(email: String) -> Bool {
		return worker.emailValid(email: email)
	}

	func passwordValid(password: String) -> Bool {
		return worker.passwordValid(password: password)
	}

	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return worker.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
	}

	func checkValid(emailValid: Bool, passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		return worker.checkValid(emailValid: emailValid, passwordValdid: passwordValdid, confirmPasswordValid: confirmPasswordValid)
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

	func emailValid(email: String) -> Bool {
		return worker.emailValid(email: email)
	}

	func passwordValid(password: String) -> Bool {
		return worker.passwordValid(password: password)
	}

	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return worker.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
	}

	func checkValid(emailValid: Bool, passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		return worker.checkValid(emailValid: emailValid, passwordValdid: passwordValdid, confirmPasswordValid: confirmPasswordValid)
	}

}
