//
//  RegisterWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Combine
import Common
import ChatSecure

protocol IRegisterWorker {
	var remoteStore: IRegisterRemoteStore { get }
	var inMemoryStore: IRegisterInMemoryStore { get }

	func register(displayName: String, email: String, password: String, customServer: CustomServer) async -> Result<Bool, Error>
	func emailValid(email: String) -> Bool
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(emailValid: Bool, passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
	func lengthPassword(_ password: String) -> Bool
}

struct RegisterWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IRegisterRemoteStore
	let inMemoryStore: IRegisterInMemoryStore
	let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
	let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*&-_])[A-Za-z\\d@$!%*&-_]{8,64}")
	init(channelStorage: IChannelStorage,
		remoteStore: IRegisterRemoteStore,
		 inMemoryStore: IRegisterInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension RegisterWorker: IRegisterWorker {
	var currentDomain: String {
		channelStorage.currentDomain
	}
	
	func register(displayName: String, email: String, password: String, customServer: CustomServer) async -> Result<Bool, Error> {
		let isCustomServer = customServer.isSelectedCustomServer && !customServer.customServerURL.isEmpty
		return await remoteStore.register(displayName: displayName, email: email, password: password, domain: isCustomServer ? customServer.customServerURL : currentDomain)
	}

	func emailValid(email: String) -> Bool {
		let result = self.emailPredicate.evaluate(with: email)
		return result
	}

	func passwordValid(password: String) -> Bool {
		let result = self.passwordPredicate.evaluate(with: password)
		return result
	}

	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		if password == confirmPassword {
			return true
		} else {
			return false
		}
	}

	func checkValid(emailValid: Bool, passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		(emailValid == false || passwordValdid == false || confirmPasswordValid == false) ?  false : true
	}
	
	func lengthPassword(_ password: String) -> Bool {
		let result = password.count >= 8 && 64 >= password.count
		return result
	}
}
