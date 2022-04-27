//
//  LoginRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 07/03/2022.
//

import Foundation
import Combine
import ChatSecure

protocol ILoginRemoteStore {
	func signIn(email: String, password: String, domain: String) async -> Result<String, Error>
	func signInSocial(_ socialType: SocialType, domain: String)
	func signOut(domain: String)
}

struct LoginRemoteStore {
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
}

extension LoginRemoteStore: ILoginRemoteStore {
	func signIn(email: String, password: String, domain: String) async -> Result<String, Error> {
		let response = await authenticationService.login(userName: email, password: password, domain: domain)
		switch response {
		case .success(let data):
			print(data)
			return .success("")
		case .failure(let error):
			print(error)
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
