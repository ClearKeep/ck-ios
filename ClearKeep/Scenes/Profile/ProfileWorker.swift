//
//  ProfileWorker.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import Common
import ChatSecure
import Model
import Foundation
import CommonUI

protocol IProfileWorker {
	var remoteStore: IProfileRemoteStore { get }
	var inMemoryStore: IProfileInMemoryStore { get }
	func getProfile() async -> Result<IProfileModels, Error>
	func uploadAvatar(url: URL, imageData: UIImage) async -> (Result<IProfileModels, Error>)
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> (Result<IProfileModels, Error>)
}

struct ProfileWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IProfileRemoteStore
	let inMemoryStore: IProfileInMemoryStore
	var currentDomain: String?

	init(channelStorage: IChannelStorage,
		 remoteStore: IProfileRemoteStore,
		 inMemoryStore: IProfileInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ProfileWorker: IProfileWorker {
	func getProfile() async -> Result<IProfileModels, Error> {
		let result = await remoteStore.getProfile(domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func uploadAvatar(url: URL, imageData: UIImage) async -> (Result<IProfileModels, Error>) {

		let fileName = url.lastPathComponent
		let fileType = "image/\(url.pathExtension)"
		let fileData = imageData.jpegData(compressionQuality: 0.1) ?? Data()
		let fileHash = md5(imageData: fileData)
		let result = await remoteStore.uploadAvatar(fileName: fileName, fileContentType: fileType, fileData: fileData, fileHash: fileHash, domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let avatar):
			return .success(avatar)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> (Result<IProfileModels, Error>) {
		let result = await remoteStore.updateProfile(displayName: displayName, avatar: avatar, phoneNumber: phoneNumber, clearPhoneNumber: clearPhoneNumber, domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let profile):
			return .success(profile)
		case .failure(let error):
			return .failure(error)
		}
	}
}
