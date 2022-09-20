//
//  FogotPasswordRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model

protocol IFogotPasswordRemoteStore {
	func recoverPassword(email: String, domain: String) async -> Result<Bool, Error>
}

struct FogotPasswordRemoteStore {
	let authenticationService: IAuthenticationService
}

extension FogotPasswordRemoteStore: IFogotPasswordRemoteStore {
	func recoverPassword(email: String, domain: String) async -> Result<Bool, Error> {
		let result = await authenticationService.recoverPassword(email: email, domain: domain)
		
		switch result {
		case .success:
			return .success(true)
		case .failure(let error):
			return .failure(error)
		}
	}
}
