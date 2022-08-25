//
//  LoginRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model
import Networking

protocol ILoginRemoteStore {
	func signIn(email: String, password: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func signInSocial(_ socialType: SocialType, domain: String) async -> Result<IAuthenticationModel, Error>
}

struct LoginRemoteStore {
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
}

extension LoginRemoteStore: ILoginRemoteStore {
	func signIn(email: String, password: String, domain: String) async -> Result<IAuthenticationModel, Error> {
		let result = await authenticationService.login(userName: email, password: password, domain: domain)
		
		switch result {
		case .success(let authenticationResponse):
			return .success(AuthenticationModel(response: authenticationResponse))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signInSocial(_ socialType: SocialType, domain: String) async -> Result<IAuthenticationModel, Error> {
		var result: Result<Auth_SocialLoginRes, Error>?
		
		switch socialType {
		case .facebook:
			result = await socialAuthenticationService.signInWithFB(domain: domain)
		case .google:
			result = await socialAuthenticationService.signInWithGoogle(domain: domain)
		case .office:
			result = await socialAuthenticationService.signInWithOffice(domain: domain)
		case .apple:
			result = await socialAuthenticationService.signInWithApple(domain: domain)
		}
		
		switch result {
		case .success(let socialLoginResponse):
			return .success(AuthenticationModel(response: socialLoginResponse))
		case .failure(let error):
			return .failure(error)
		case .none:
			return .failure(ServerError.unknown)
		}
	}
}
