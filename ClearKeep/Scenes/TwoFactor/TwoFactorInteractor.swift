//
//  TwoFactorInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common
import ChatSecure

protocol ITwoFactorInteractor {
	var worker: ITwoFactorWorker { get }
	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async
}

struct TwoFactorInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
}

extension TwoFactorInteractor: ITwoFactorInteractor {
	var worker: ITwoFactorWorker {
		let remoteStore = TwoFactorRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = TwoFactorInMemoryStore()
		return TwoFactorWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async {
		let result = await worker.validateOTP(userId: userId, otp: otp, otpHash: otpHash, haskKey: haskKey, domain: domain)
	}
}

struct StubTwoFactorInteractor: ITwoFactorInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService

	var worker: ITwoFactorWorker {
		let remoteStore = TwoFactorRemoteStore(authenticationService: authenticationService)
		let inMemoryStore = TwoFactorInMemoryStore()
		return TwoFactorWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async {

	}
}
