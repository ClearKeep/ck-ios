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
	func validateOTP(otp: String, domain: String) async -> Result<Bool, Error>
	func validatePassword(password: String, domain: String) async -> Result<Bool, Error>
	func resendOTP(domain: String) async -> Result<Bool, Error>
	func resendLoginOTP(userId: String, otpHash: String, domain: String) async -> Result<Bool, Error>
	func validateLoginOTP(password: String, userId: String, otpHash: String, otp: String, domain: String) async -> Result<Bool, Error>
}

struct TwoFactorRemoteStore {
	let userService: IUserService
	let authService: IAuthenticationService
}

extension TwoFactorRemoteStore: ITwoFactorRemoteStore {
	func validateOTP(otp: String, domain: String) async -> Result<Bool, Error> {
		let response = await userService.mfaValidateOTP(otp: otp, domain: domain)
		switch response {
		case .success(let data):
			return .success(data.success)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func validatePassword(password: String, domain: String) async -> Result<Bool, Error> {
		let response = await userService.validatePassword(password: password, domain: domain)
		switch response {
		case .success(let data):
			return .success(data.success)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func resendOTP(domain: String) async -> Result<Bool, Error> {
		let response = await userService.mfaResendOTP(domain: domain)
		switch response {
		case .success(let data):
			return .success(data.success)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func resendLoginOTP(userId: String, otpHash: String, domain: String) async -> Result<Bool, Error> {
		let response = await authService.mfaResendOTP(userId: userId, otpHash: otpHash, domain: domain)
		switch response {
		case .success(let data):
			return .success(data.success)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func validateLoginOTP(password: String, userId: String, otpHash: String, otp: String, domain: String) async -> Result<Bool, Error> {
		let response = await authService.validateOTP(password: password, userId: userId, otp: otp, otpHash: otpHash, haskKey: "", domain: domain)
		switch response {
		case .success(let data):
			print(data)
			return .success(true)
		case .failure(let error):
			return .failure(error)
		}
	}
}
