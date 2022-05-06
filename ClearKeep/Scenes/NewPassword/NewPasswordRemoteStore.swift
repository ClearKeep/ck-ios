//
//  NewPasswordRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure

protocol INewPasswordRemoteStore {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
}

struct NewPasswordRemoteStore {
	let authenticationService: IAuthenticationService
}

extension NewPasswordRemoteStore: INewPasswordRemoteStore {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
		await authenticationService.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
	}
}
