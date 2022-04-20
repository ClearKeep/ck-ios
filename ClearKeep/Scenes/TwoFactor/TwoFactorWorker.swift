//
//  TwoFactorWorker.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Combine
import Common
import ChatSecure

protocol ITwoFactorWorker {
	var remoteStore: ITwoFactorRemoteStore { get }
	var inMemoryStore: ITwoFactorInMemoryStore { get }
	var currentDomain: String { get }

	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async
}

struct TwoFactorWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ITwoFactorRemoteStore
	let inMemoryStore: ITwoFactorInMemoryStore
	
	init(channelStorage: IChannelStorage, remoteStore: ITwoFactorRemoteStore,
		 inMemoryStore: ITwoFactorInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension TwoFactorWorker: ITwoFactorWorker {
	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async {
		<#code#>
	}

	var currentDomain: String {
		channelStorage.currentChannel.domain
	}
}
