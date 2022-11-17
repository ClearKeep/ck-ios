//
//  NewPasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Combine
import Common
import ChatSecure
import Model

protocol INewPasswordWorker {
	var remoteStore: INewPasswordRemoteStore { get }
	var inMemoryStore: INewPasswordInMemoryStore { get }
	var servers: [ServerModel] { get }

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
	func lengthPassword(_ password: String) -> Bool
}

struct NewPasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: INewPasswordRemoteStore
	let inMemoryStore: INewPasswordInMemoryStore
	let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&\"*()\\-_=+{};:,<.>])[A-Za-z\\d!@#$%^&\"*()\\-_=+{};:,<.>]{8,64}")
	init(channelStorage: IChannelStorage, remoteStore: INewPasswordRemoteStore,
		 inMemoryStore: INewPasswordInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
		self.channelStorage = channelStorage
	}
}

extension NewPasswordWorker: INewPasswordWorker {
	var servers: [ServerModel] {
		channelStorage.getServers(isFirstLoad: false).compactMap { ServerModel($0) }
	}
	
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		return await remoteStore.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
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

	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		(passwordValdid == false || confirmPasswordValid == false) ?  false : true
	}
	
	func lengthPassword(_ password: String) -> Bool {
		let result = password.count >= 8 && 64 >= password.count
		return result
	}
}
