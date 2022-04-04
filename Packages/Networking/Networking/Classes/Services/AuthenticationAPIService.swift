//
//  IAuthenticationAPIService.swift
//  
//
//  Created by NamNH on 21/02/2022.
//

import Foundation

public protocol IAuthenticationAPIService {
	func login(_ request: Auth_AuthChallengeReq) async -> (Result<Auth_AuthChallengeRes, Error>)
	func login(_ request: Auth_AuthenticateReq) async -> (Result<Auth_AuthRes, Error>)
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
	public func login(_ request: Auth_AuthChallengeReq) async -> (Result<Auth_AuthChallengeRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.login_challenge(request).response
			let status = clientAuth.login_challenge(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func login(_ request: Auth_AuthenticateReq) async -> (Result<Auth_AuthRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.login_authenticate(request).response
			let status = clientAuth.login_authenticate(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func login(_ request: Auth_GoogleLoginReq) async -> (Result<Auth_SocialLoginRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.login_google(request).response
			let status = clientAuth.login_google(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func login(_ request: Auth_OfficeLoginReq) async -> (Result<Auth_SocialLoginRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.login_office(request).response
			let status = clientAuth.login_office(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func login(_ request: Auth_FacebookLoginReq) async -> (Result<Auth_SocialLoginRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.login_facebook(request).response
			let status = clientAuth.login_facebook(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func registerSRP(_ request: Auth_RegisterSRPReq) async -> (Result<Auth_RegisterSRPRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.register_srp(request).response
			let status = clientAuth.register_srp(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func registerPinCode(_ request: Auth_RegisterPinCodeReq) async -> (Result<Auth_AuthRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.register_pincode(request).response
			let status = clientAuth.register_pincode(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func forgotPassword(_ request: Auth_ForgotPasswordReq) async -> (Result<Auth_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.forgot_password(request).response
			let status = clientAuth.forgot_password(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func forgotPasswordUpdate(_ request: Auth_ForgotPasswordUpdateReq) async -> (Result<Auth_AuthRes, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.forgot_password_update(request).response
			let status = clientAuth.forgot_password_update(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func logout(_ request: Auth_LogoutReq) async -> (Result<Auth_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let response = clientAuth.logout(request).response
			let status = clientAuth.logout(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
}
