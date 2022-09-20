//
//  NewPasswordRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model

protocol INewPasswordRemoteStore {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error>
}

struct NewPasswordRemoteStore {
	let authenticationService: IAuthenticationService
}

extension NewPasswordRemoteStore: INewPasswordRemoteStore {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		let result = await authenticationService.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
		
		switch result {
		case .success(let authenticationResponse):
			return .success(AuthenticationModel(response: authenticationResponse))
		case .failure(let error):
			return .failure(error)
		}
	}
}
