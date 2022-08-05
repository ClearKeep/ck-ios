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
		let result = oldpassword.count >= 6 && 12 >= oldpassword.count
		return result
	}

	func passwordValid(password: String) -> Bool {
		let result = password.count >= 6 && 12 >= password.count
		return result
	}

	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return password == confirmPassword
	}

	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		(passwordValdid == false || confirmPasswordValid == false) ?  false : true
	}
}
