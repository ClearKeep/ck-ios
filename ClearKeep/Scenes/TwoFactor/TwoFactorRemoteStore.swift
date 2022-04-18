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
	func signIn(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async -> Result<String, Error>
}

struct TwoFactorRemoteStore {
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
}

extension TwoFactorRemoteStore: ITwoFactorRemoteStore {
	func signIn(userId: String, otp: String, otpHash: String, haskKey: String, domain: String) async -> Result<String, Error> {
		let response = await authenticationService.validateOTP(userId: userId, otp: otp, otpHash: otpHash, haskKey: haskKey, domain: domain)
		switch response {
		case .success(let data):
			print(data)
			return .success("")
		case .failure(let error):
			return .failure(error)
		}
	}

}
