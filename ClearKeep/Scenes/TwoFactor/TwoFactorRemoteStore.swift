//
//  TwoFactorRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Foundation
import Combine
import ChatSecure

protocol ITwoFactorRemoteStore {
	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async
}

struct TwoFactorRemoteStore {
	let authenticationService: IAuthenticationService
}

extension TwoFactorRemoteStore: ITwoFactorRemoteStore {
	func validateOTP(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async {
		let response = await authenticationService.validateOTP(userId: userId, otp: otp, otpHash: otpHash, haskKey: haskKey, domain: domain)

	}

}
