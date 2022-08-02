//
//  SocialRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Foundation
import ChatSecure
import Model

protocol ISocialRemoteStore {
	func registerSocialPin(rawPin: String, userId: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func verifySocialPin(rawPin: String, userId: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func resetSocialPin(rawPin: String, userId: String, token: String, domain: String) async -> Result<IAuthenticationModel, Error>
}

struct SocialRemoteStore {
	let authenticationService: IAuthenticationService
}

extension SocialRemoteStore: ISocialRemoteStore {
	func registerSocialPin(rawPin: String, userId: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		let result = await authenticationService.registerSocialPin(rawPin: rawPin, userId: userId, domain: domain)
		
		switch result {
		case .success(let authenticationResponse):
			return .success(AuthenticationModel(response: authenticationResponse))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func verifySocialPin(rawPin: String, userId: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		let result = await authenticationService.verifySocialPin(rawPin: rawPin, userId: userId, domain: domain)
		
		switch result {
		case .success(let authenticationResponse):
			return .success(AuthenticationModel(response: authenticationResponse))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func resetSocialPin(rawPin: String, userId: String, token: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		let result = await authenticationService.resetSocialPin(rawPin: rawPin, token: token, userId: userId, domain: domain)
		
		switch result {
		case .success:
			return await self.verifySocialPin(rawPin: rawPin, userId: userId, domain: domain)
		case .failure(let error):
			return .failure(error)
		}
	}
}
