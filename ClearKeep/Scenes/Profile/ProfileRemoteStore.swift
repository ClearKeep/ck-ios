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
	func getMfaSettings(domain: String) async -> Result<Bool, Error>
	func updateMfaSettings(domain: String, enabled: Bool) async -> Result<Bool, Error>
	func deleteUser(domain: String) async -> Result<Bool, Error>
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
	
	func getMfaSettings(domain: String) async -> Result<Bool, Error> {
		let result = await userService.getMfaState(domain: domain)
		switch result {
		case .success(let data):
			return .success(data.mfaEnable)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func updateMfaSettings(domain: String, enabled: Bool) async -> Result<Bool, Error> {
		let result = await userService.updateMfaSettings(domain: domain, enabled: enabled)
		switch result {
		case .success(let data):
			print("update mfa setting success: \(data)")
			return .success(data.success)
		case .failure(let error):
			print("update mfa setting fail: \(error)")
			return .failure(error)
		}
	}

	func deleteUser(domain: String) async -> Result<Bool, Error> {
		let result = await userService.deleteUser(domain: domain)
		switch result {
		case .success(let data):
			print("delete user success: \(data)")
			return .success(true)
		case .failure(let error):
			print("delete user fail: \(error)")
			return .failure(error)
		}
	}
}
