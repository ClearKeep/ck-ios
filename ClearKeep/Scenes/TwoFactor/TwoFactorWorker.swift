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

	func validateOTP(otp: String) async -> Result<Bool, Error>
	func validatePassword(password: String) async -> Result<Bool, Error>
	func resendOTP() async -> Result<Bool, Error>
	func resendLoginOTP(userId: String, otpHash: String, domain: String) async -> Result<Bool, Error>
	func validateLoginOTP(password: String, userId: String, otpHash: String, otp: String, domain: String) async -> Result<Bool, Error>
}

struct TwoFactorWorker {
	// MARK: - Variables
	let channelStorage: IChannelStorage
	let remoteStore: ITwoFactorRemoteStore
	let inMemoryStore: ITwoFactorInMemoryStore

	// MARK: - Init
	init(channelStorage: IChannelStorage,
		 remoteStore: ITwoFactorRemoteStore,
		 inMemoryStore: ITwoFactorInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension TwoFactorWorker: ITwoFactorWorker {
	func resendOTP() async -> Result<Bool, Error> {
		return await remoteStore.resendOTP(domain: currentDomain)
	}
	
	func validateOTP(otp: String) async -> Result<Bool, Error> {
		return await remoteStore.validateOTP(otp: otp, domain: currentDomain)
	}

	func validatePassword(password: String) async -> Result<Bool, Error> {
		return await remoteStore.validatePassword(password: password, domain: currentDomain)
	}
	
	func resendLoginOTP(userId: String, otpHash: String, domain: String) async -> Result<Bool, Error> {
		return await remoteStore.resendLoginOTP(userId: userId, otpHash: otpHash, domain: domain)
	}
	
	func validateLoginOTP(password: String, userId: String, otpHash: String, otp: String, domain: String) async -> Result<Bool, Error> {
		return await remoteStore.validateLoginOTP(password: password, userId: userId, otpHash: otpHash, otp: otp, domain: domain)
	}
	
	var currentDomain: String {
		channelStorage.currentDomain
	}
}
