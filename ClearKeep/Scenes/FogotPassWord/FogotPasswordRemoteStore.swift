//
//  FogotPasswordRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure

protocol IFogotPasswordRemoteStore {
	func recoverPassword(email: String, domain: String) async
}

struct FogotPasswordRemoteStore {
	let authenticationService: IAuthenticationService
}

extension FogotPasswordRemoteStore: IFogotPasswordRemoteStore {
	func recoverPassword(email: String, domain: String) async {
		await authenticationService.recoverPassword(email: email, domain: domain)
	}
}
