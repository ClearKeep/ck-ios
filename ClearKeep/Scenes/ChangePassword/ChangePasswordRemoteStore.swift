//
//  ChangePasswordRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model
import Networking

protocol IChangePasswordRemoteStore {
	func changePassword(oldPassword: String, newPassword: String, domain: String) async -> Result<IChangePasswordModels, Error>
}

struct ChangePasswordRemoteStore {
	let authenticationService: IAuthenticationService
	let userService: IUserService
}

extension ChangePasswordRemoteStore: IChangePasswordRemoteStore {
	func changePassword(oldPassword: String, newPassword: String, domain: String) async -> Result<IChangePasswordModels, Error> {
		let result = await userService.changePassword(oldPassword: oldPassword, newPassword: newPassword, domain: domain)
		switch result {
		case .success(let authenRespone):
			return .success(ChangePasswordModels(responseError: authenRespone))
		case .failure(let error):
			return .failure(error)
		}
	}
}
