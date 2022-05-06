//
//  ChangePasswordRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model
import Networking

protocol IChangePasswordRemoteStore {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async
}

struct ChangePasswordRemoteStore {
	let authenticationService: IAuthenticationService
}

extension ChangePasswordRemoteStore: IChangePasswordRemoteStore {
	func resetPassword(preAccessToken: String, email: String, rawNewPassword: String, domain: String) async {
		await authenticationService.resetPassword(preAccessToken: preAccessToken, email: email, rawNewPassword: rawNewPassword, domain: domain)
	}
}
