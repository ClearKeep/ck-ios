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

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
}

struct NewPasswordWorker {
	let remoteStore: INewPasswordRemoteStore
	let inMemoryStore: INewPasswordInMemoryStore
	let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "[0-9a-zA-Z._%+-?=.*[ !$%&?._-]]{6,12}")
	init(remoteStore: INewPasswordRemoteStore,
		 inMemoryStore: INewPasswordInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension NewPasswordWorker: INewPasswordWorker {
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
}
