//
//  RegisterRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Foundation
import Combine
import ChatSecure

protocol IRegisterRemoteStore {
	func register(displayName: String, email: String, password: String, domain: String) async -> Result<Bool, Error>
}

struct RegisterRemoteStore {
	let authenticationService: IAuthenticationService
}

extension RegisterRemoteStore: IRegisterRemoteStore {
	func register(displayName: String, email: String, password: String, domain: String) async -> Result<Bool, Error> {
		let result = await authenticationService.register(displayName: displayName, email: email, password: password, domain: domain)
		switch result {
		case .success:
			return .success(true)
		case .failure(let error):
			return .failure(error)
		}
	}
}
