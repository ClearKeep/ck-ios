//
//  ChangePasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Combine
import Common
import ChatSecure
import Model

protocol IChangePasswordWorker {
	var remoteStore: IChangePasswordRemoteStore { get }
	var inMemoryStore: IChangePasswordInMemoryStore { get }
	func changePassword(oldPassword: String, newPassword: String) async -> Result<IChangePasswordModels, Error>
	func oldValid(oldpassword: String) -> Bool
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
}

struct ChangePasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IChangePasswordRemoteStore
	let inMemoryStore: IChangePasswordInMemoryStore
	let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "[0-9a-zA-Z._%+-]{6,12}")
	var currentDomain: String?

	init(channelStorage: IChannelStorage,
		 remoteStore: IChangePasswordRemoteStore,
		 inMemoryStore: IChangePasswordInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChangePasswordWorker: IChangePasswordWorker {
	func changePassword(oldPassword: String, newPassword: String) async -> Result<IChangePasswordModels, Error> {
		return await remoteStore.changePassword(oldPassword: oldPassword, newPassword: newPassword, domain: currentDomain ?? channelStorage.currentDomain)
	}

	func oldValid(oldpassword: String) -> Bool {
		let result = self.passwordPredicate.evaluate(with: oldpassword)
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

	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		(passwordValdid == false || confirmPasswordValid == false) ?  false : true
	}
}
