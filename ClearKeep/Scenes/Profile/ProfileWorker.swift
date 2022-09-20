//
//  ProfileWorker.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import Common
import ChatSecure
import Model
import CommonUI
import PhoneNumberKit

private enum Constants {
	static let maxAvatarSize = 5_000_000 // 5MB
}

protocol IProfileWorker {
	var remoteStore: IProfileRemoteStore { get }
	var inMemoryStore: IProfileInMemoryStore { get }
	var servers: [ServerModel] { get }

	func getProfile() async -> Result<IProfileModels, Error>
	func uploadAvatar(url: URL, imageData: UIImage) async -> (Result<IProfileModels, Error>)
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> (Result<IProfileModels, Error>)
	func validate(phoneNumber: String) -> Bool
	func getMfaSettings() async -> Result<Bool, Error>
	func updateMfaSettings(enabled: Bool) async -> Result<Bool, Error>
	func isValidAvatarSize(url: URL) -> Bool
	func deleteUser() async -> Result<Bool, Error>
	func removeServer()
}

struct ProfileWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IProfileRemoteStore
	let inMemoryStore: IProfileInMemoryStore
	var currentDomain: String?
	let phoneNumberKit = PhoneNumberKit()
	
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
		let fileData = imageData.jpegData(compressionQuality: 1) ?? Data()
		let fileHash = fileData.md5().map { String(format: "%02hhx", $0) }.joined()
		let result = await remoteStore.uploadAvatar(fileName: fileName, fileContentType: fileType, fileData: fileData, fileHash: fileHash, domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let avatar):
			return .success(avatar)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func updateProfile(displayName: String, avatar: String, phoneNumber: String, clearPhoneNumber: Bool) async -> (Result<IProfileModels, Error>) {
		let domain = currentDomain ?? channelStorage.currentDomain
		let result = await remoteStore.updateProfile(displayName: displayName, avatar: avatar, phoneNumber: phoneNumber, clearPhoneNumber: clearPhoneNumber, domain: domain)
		
		switch result {
		case .success(let profile):
			channelStorage.updateServerUser(displayName: displayName, avatar: avatar, phoneNumber: phoneNumber, domain: domain)
			return .success(profile)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func validate(phoneNumber: String) -> Bool {
		do {
			_ = try phoneNumberKit.parse(phoneNumber)
			return true
		} catch {
			return false
		}
	}
	
	func getMfaSettings() async -> Result<Bool, Error> {
		return await remoteStore.getMfaSettings(domain: currentDomain ?? channelStorage.currentDomain)
	}
	
	func updateMfaSettings(enabled: Bool) async -> Result<Bool, Error> {
		return await remoteStore.updateMfaSettings(domain: currentDomain ?? channelStorage.currentDomain, enabled: enabled)
	}
	
	func isValidAvatarSize(url: URL) -> Bool {
		do {
			_ = url.startAccessingSecurityScopedResource()
			let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
			let size = attributes[.size] as? Int64 ?? 0
			return size < Constants.maxAvatarSize
		} catch {
			return false
		}
	}

	func deleteUser() async -> Result<Bool, Error> {
		return await remoteStore.deleteUser(domain: currentDomain ?? channelStorage.currentDomain)
	}

	var servers: [ServerModel] {
		channelStorage.getServers(isFirstLoad: false).compactMap({
			ServerModel($0)
		})
	}

	func removeServer() {
		let domain = currentDomain ?? channelStorage.currentDomain
		if let currentServer = channelStorage.currentServer {
			channelStorage.removeUser(currentServer)
		}
		channelStorage.removeProfile(channelStorage.currentServer?.ownerClientId ?? "")
		channelStorage.removeServer(domain)
		channelStorage.removeGroup(domain)
	}
}
