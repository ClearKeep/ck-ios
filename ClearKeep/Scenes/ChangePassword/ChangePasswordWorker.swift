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
}

struct ChangePasswordWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IChangePasswordRemoteStore
	let inMemoryStore: IChangePasswordInMemoryStore
	
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
}
