//
//  ChangePasswordInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import Model

protocol IChangePasswordInteractor {
	var worker: IChangePasswordWorker { get }
	func changePassword(oldPassword: String, newPassword: String) async -> Result<IChangePasswordModels, Error>
	func oldPassValid(oldpassword: String) -> Bool
	func passwordValid(password: String) -> Bool
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool
}

struct ChangePasswordInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let userService: IUserService
}

extension ChangePasswordInteractor: IChangePasswordInteractor {
	
	var worker: IChangePasswordWorker {
		let remoteStore = ChangePasswordRemoteStore(authenticationService: authenticationService, userService: userService)
		let inMemoryStore = ChangePasswordInMemoryStore()
		return ChangePasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func changePassword(oldPassword: String, newPassword: String) async -> Result<IChangePasswordModels, Error> {
		let result = await worker.changePassword(oldPassword: oldPassword, newPassword: newPassword)
		
		switch result {
		case .success(let groupResponse):
			return .success(groupResponse)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func oldPassValid(oldpassword: String) -> Bool {
		return worker.oldValid(oldpassword: oldpassword)
	}
	
	func passwordValid(password: String) -> Bool {
		return worker.passwordValid(password: password)
	}
	
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return worker.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
	}
	
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		return worker.checkValid(passwordValdid: passwordValdid, confirmPasswordValid: confirmPasswordValid)
	}
}

struct StubChangePasswordInteractor: IChangePasswordInteractor {
	let channelStorage: IChannelStorage
	let authenticationService: IAuthenticationService
	let userService: IUserService
	
	var worker: IChangePasswordWorker {
		let remoteStore = ChangePasswordRemoteStore(authenticationService: authenticationService, userService: userService)
		let inMemoryStore = ChangePasswordInMemoryStore()
		return ChangePasswordWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func changePassword(oldPassword: String, newPassword: String) async -> Result<IChangePasswordModels, Error> {
		let result = await worker.changePassword(oldPassword: oldPassword, newPassword: newPassword)
		
		switch result {
		case .success(let groupResponse):
			return .success(groupResponse)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func passwordValid(password: String) -> Bool {
		return worker.passwordValid(password: password)
	}
	
	func confirmPasswordValid(password: String, confirmPassword: String) -> Bool {
		return worker.confirmPasswordValid(password: password, confirmPassword: confirmPassword)
	}
	
	func checkValid(passwordValdid: Bool, confirmPasswordValid: Bool) -> Bool {
		return worker.checkValid(passwordValdid: passwordValdid, confirmPasswordValid: confirmPasswordValid)
	}
	
	func oldPassValid(oldpassword: String) -> Bool {
		return worker.oldValid(oldpassword: oldpassword)
	}
}
