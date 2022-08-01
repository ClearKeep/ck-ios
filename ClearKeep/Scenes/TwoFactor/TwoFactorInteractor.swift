//
//  TwoFactorInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common
import ChatSecure

protocol ITwoFactorInteractor {
	var worker: ITwoFactorWorker { get }
	func validateOTP(loadable: LoadableSubject<Bool>, otp: String) async -> Bool
	func validatePassword(password: String) async -> Loadable<Bool>
	func resendOTP(loadable: LoadableSubject<Bool>) async
	func validateLoginOTP(loadable: LoadableSubject<Bool>, password: String, otp: String, userId: String, otpHash: String, domain: String) async
	func resendLoginOTP(loadable: LoadableSubject<Bool>, userId: String, otpHash: String, domain: String) async
}

struct TwoFactorInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let userService: IUserService
	let authService: IAuthenticationService
}

extension TwoFactorInteractor: ITwoFactorInteractor {
	var worker: ITwoFactorWorker {
		let remoteStore = TwoFactorRemoteStore(userService: userService, authService: authService)
		let inMemoryStore = TwoFactorInMemoryStore()
		return TwoFactorWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func validateOTP(loadable: LoadableSubject<Bool>, otp: String) async -> Bool {
		loadable.wrappedValue.setIsLoading(cancelBag: CancelBag())
		let result = await worker.validateOTP(otp: otp)
		switch result {
		case .success(let value):
			loadable.wrappedValue.cancelLoading()
			return value
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
			return false
		}
	}
	
	func validatePassword(password: String) async -> Loadable<Bool> {
		guard isValidPassword(password: password) else {
			return .failed(TwoFactorError.invalidPassword)
		}
		let result = await worker.validatePassword(password: password)
		switch result {
		case .success(let value):
			return .loaded(value)
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func resendOTP(loadable: LoadableSubject<Bool>) async {
		let result = await worker.resendOTP()
		switch result {
		case .success(let value):
			print(value)
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
		}
	}
	
	func validateLoginOTP(loadable: LoadableSubject<Bool>, password: String, otp: String, userId: String, otpHash: String, domain: String) async {
		loadable.wrappedValue.setIsLoading(cancelBag: CancelBag())
		let result = await worker.validateLoginOTP(password: password, userId: userId, otpHash: otpHash, otp: otp, domain: domain)
		switch result {
		case .success(let value):
			print(value)
			appState[\.authentication.servers] = channelStorage.getServers(isFirstLoad: false).compactMap { ServerModel($0) }
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
		}
	}
	
	func resendLoginOTP(loadable: LoadableSubject<Bool>, userId: String, otpHash: String, domain: String) async {
		let result = await worker.resendLoginOTP(userId: userId, otpHash: otpHash, domain: domain)
		switch result {
		case .success(let value):
			print(value)
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
		}
	}
	
	func isValidPassword(password: String) -> Bool {
		return password.count >= 6 && password.count <= 12
	}
}

struct StubTwoFactorInteractor: ITwoFactorInteractor {
	let channelStorage: IChannelStorage
	let userService: IUserService
	let authService: IAuthenticationService

	var worker: ITwoFactorWorker {
		let remoteStore = TwoFactorRemoteStore(userService: userService, authService: authService)
		let inMemoryStore = TwoFactorInMemoryStore()
		return TwoFactorWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func validateOTP(loadable: LoadableSubject<Bool>, otp: String) async -> Bool {
		return true
	}
	
	func validatePassword(password: String) async -> Loadable<Bool> {
		return .notRequested
	}
	
	func resendOTP(loadable: LoadableSubject<Bool>) async {
		
	}
	
	func validateLoginOTP(loadable: LoadableSubject<Bool>, password: String, otp: String, userId: String, otpHash: String, domain: String) async {
	}
	
	func resendLoginOTP(loadable: LoadableSubject<Bool>, userId: String, otpHash: String, domain: String) async {
		
	}
}
