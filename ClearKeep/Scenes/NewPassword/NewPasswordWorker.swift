//
//  NewPasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Combine
import Common
import ChatSecure

protocol INewPasswordWorker {
	var remoteStore: INewPasswordRemoteStore { get }
	var inMemoryStore: INewPasswordInMemoryStore { get }

	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
}

struct NewPasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: INewPasswordRemoteStore
	let inMemoryStore: INewPasswordInMemoryStore
	
	init(channelStorage: IChannelStorage,
		 remoteStore: INewPasswordRemoteStore,
		 inMemoryStore: INewPasswordInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension NewPasswordWorker: INewPasswordWorker {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
		return await remoteStore.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
	}
}
