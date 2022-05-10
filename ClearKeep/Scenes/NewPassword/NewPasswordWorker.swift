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
}

struct NewPasswordWorker {
	let remoteStore: INewPasswordRemoteStore
	let inMemoryStore: INewPasswordInMemoryStore
	
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
}
