//
//  ProfileInteractor.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import Common
import ChatSecure
import Model
import UIKit

protocol IProfileInteractor {
	var worker: IProfileWorker { get }
	func getProfile() async -> Loadable<IProfileViewModels>
	func uploadAvatar(url: URL, imageData: UIImage) async -> Loadable<IProfileViewModels>
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> Loadable<IProfileViewModels>
}

struct ProfileInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let userService: IUserService
}

extension ProfileInteractor: IProfileInteractor {

	var worker: IProfileWorker {
		let remoteStore = ProfileRemoteStore(userService: userService)
		let inMemoryStore = ProfileInMemoryStore()
		return ProfileWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func getProfile() async -> Loadable<IProfileViewModels> {
		let result = await worker.getProfile()

		switch result {
		case .success(let user):
			return .loaded(ProfileViewModels(responseUser: user))
		case .failure(let error):
			return .failed(error)
		}
	}

	func uploadAvatar(url: URL, imageData: UIImage) async -> Loadable<IProfileViewModels> {

		let result = await worker.uploadAvatar(url: url, imageData: imageData)

		switch result {
		case .success(let imageData):
			let result = await worker.getProfile()

			switch result {
			case .success(let user):
				return .loaded(ProfileViewModels(responseAvatar: imageData, responseUser: user))
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}

	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> Loadable<IProfileViewModels> {
		let result = await worker.updateProfile(displayName: displayName, avatar: avatar, phoneNumber: phoneNumber, clearPhoneNumber: clearPhoneNumber)
		switch result {
		case .success(let updateProfile):
			return .loaded(ProfileViewModels(responBase: updateProfile))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubProfileInteractor: IProfileInteractor {

	let channelStorage: IChannelStorage
	let userService: IUserService

	var worker: IProfileWorker {
		let remoteStore = ProfileRemoteStore(userService: userService)
		let inMemoryStore = ProfileInMemoryStore()
		return ProfileWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func getProfile() async -> Loadable<IProfileViewModels> {
		return .notRequested
	}

	func uploadAvatar(imageData: ProfileUploadImageViewModel) async -> Loadable<IProfileViewModels> {
		return .notRequested
	}

	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> Loadable<IProfileViewModels> {
		return .notRequested
	}
	
	func uploadAvatar(url: URL, imageData: UIImage) async -> Loadable<IProfileViewModels> {
		return .notRequested
	}

}
