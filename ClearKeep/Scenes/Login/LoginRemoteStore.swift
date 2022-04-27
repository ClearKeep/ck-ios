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

protocol ILoginRemoteStore {
	func signIn(email: String, password: String, domain: String) async -> Result<IAuthenticationModel, Error>
	func signInSocial(_ socialType: SocialType, domain: String)
	func signOut(domain: String)
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
	
	func signInSocial(_ socialType: SocialType, domain: String) {
		switch socialType {
		case .facebook:
			socialAuthenticationService.signInWithFB(domain: domain)
		case .google:
			socialAuthenticationService.signInWithGoogle(domain: domain)
		case .office:
			socialAuthenticationService.signInWithOffice(domain: domain)
		}
	}
	
	func signOut(domain: String) {
	}
}
