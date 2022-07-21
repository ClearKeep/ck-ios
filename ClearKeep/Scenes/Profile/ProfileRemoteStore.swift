//
//  ProfileRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import Foundation
import Combine
import ChatSecure
import Model

protocol IProfileRemoteStore {
	func uploadAvatar(fileName: String, fileContentType: String, fileData: Data, fileHash: String, domain: String) async -> (Result<IProfileModels, Error>)
	func getProfile(domain: String) async -> Result<IProfileModels, Error>
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool, domain: String) async -> (Result<IProfileModels, Error>)
}

struct ProfileRemoteStore {
	let userService: IUserService
}

extension ProfileRemoteStore: IProfileRemoteStore {
	func uploadAvatar(fileName: String, fileContentType: String, fileData: Data, fileHash: String, domain: String) async -> (Result<IProfileModels, Error>) {
		let result = await userService.uploadAvatar(fileName: fileName, fileContentType: fileContentType, fileData: fileData, fileHash: fileHash, domain: domain)
		switch result {
		case .success(let avatar):
			return .success(ProfileModels(responseAvatar: avatar))
		case .failure(let error):
			return .failure(error)
		}
	}

	func getProfile(domain: String) async -> Result<IProfileModels, Error> {
		let result = await userService.getProfile(domain: domain)

		switch result {
		case .success(let user):
			return .success(ProfileModels(responseProfile: user))
		case .failure(let error):
			return .failure(error)
		}
	}

	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool, domain: String) async -> (Result<IProfileModels, Error>) {
		let result = await userService.updateProfile(displayName: displayName, avatar: avatar, phoneNumber: phoneNumber, clearPhoneNumber: clearPhoneNumber, domain: domain)

		switch result {
		case .success(let user):
			return .success(ProfileModels(responseError: user))
		case .failure(let error):
			return .failure(error)
		}
	}
}
