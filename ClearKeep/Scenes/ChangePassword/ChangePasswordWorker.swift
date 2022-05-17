//
//  ChangePasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Combine
import Common
import ChatSecure

protocol IChangePasswordWorker {
	var remoteStore: IChangePasswordRemoteStore { get }
	var inMemoryStore: IChangePasswordInMemoryStore { get }
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
}

struct ChangePasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IChangePasswordRemoteStore
	let inMemoryStore: IChangePasswordInMemoryStore
	let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "[0-9a-zA-Z._%+-]{6,12}")

	init(channelStorage: IChannelStorage,
		 remoteStore: IChangePasswordRemoteStore,
		 inMemoryStore: IChangePasswordInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChangePasswordWorker: IChangePasswordWorker {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
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
}
