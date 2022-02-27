//
//  IAuthenticationAPIService.swift
//  
//
//  Created by NamNH on 21/02/2022.
//

import Foundation

protocol IAuthenticationAPIService {
	func login(_ request: Auth_AuthChallengeReq) async -> (Result<Auth_AuthChallengeRes, Error>)
	func login(_ request: Auth_GoogleLoginReq) async -> (Result<Auth_SocialLoginRes, Error>)
	func login(_ request: Auth_OfficeLoginReq) async -> (Result<Auth_SocialLoginRes, Error>)
	func login(_ request: Auth_FacebookLoginReq) async -> (Result<Auth_SocialLoginRes, Error>)
	func registerSRP(_ request: Auth_RegisterSRPReq) async -> (Result<Auth_RegisterSRPRes, Error>)
	func registerPinCode(_ request: Auth_RegisterPinCodeReq) async -> (Result<Auth_AuthRes, Error>)
	func forgotPassword(_ request: Auth_ForgotPasswordReq) async -> (Result<Auth_BaseResponse, Error>)
	func forgotPasswordUpdate(_ request: Auth_ForgotPasswordUpdateReq) async -> (Result<Auth_AuthRes, Error>)
	func logout(_ request: Auth_LogoutReq) async -> (Result<Auth_BaseResponse, Error>)
}

extension APIService: IAuthenticationAPIService {
	func login(_ request: Auth_AuthChallengeReq) async -> (Result<Auth_AuthChallengeRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.login_challenge(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func login(_ request: Auth_GoogleLoginReq) async -> (Result<Auth_SocialLoginRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.login_google(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func login(_ request: Auth_OfficeLoginReq) async -> (Result<Auth_SocialLoginRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.login_office(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func login(_ request: Auth_FacebookLoginReq) async -> (Result<Auth_SocialLoginRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.login_facebook(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func registerSRP(_ request: Auth_RegisterSRPReq) async -> (Result<Auth_RegisterSRPRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.register_srp(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func registerPinCode(_ request: Auth_RegisterPinCodeReq) async -> (Result<Auth_AuthRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.register_pincode(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func forgotPassword(_ request: Auth_ForgotPasswordReq) async -> (Result<Auth_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.forgot_password(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func forgotPasswordUpdate(_ request: Auth_ForgotPasswordUpdateReq) async -> (Result<Auth_AuthRes, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.forgot_password_update(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func logout(_ request: Auth_LogoutReq) async -> (Result<Auth_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			clientAuth.logout(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
}
