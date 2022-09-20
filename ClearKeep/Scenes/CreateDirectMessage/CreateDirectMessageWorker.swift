//
//  CreateDirectMessageWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import Foundation
import Model
import ChatSecure

protocol ICreateDirectMessageWorker {
	var remoteStore: ICreateDirectMessageRemoteStore { get }
	var inMemoryStore: ICreateDirectMessageInMemoryStore { get }

	func searchUser(keyword: String) async -> (Result<ICreatePeerModels, Error>)
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> (Result<ICreatePeerModels, Error>)
	func getProfile() async -> Result<ICreatePeerModels, Error>
	func getUserInfor(clientId: String, workspaceDomain: String) async -> (Result<ICreatePeerModels, Error>)
	func searchUserWithEmail(email: String) async -> (Result<ICreatePeerModels, Error>)
	func checkPeopleLink(link: String) -> Bool
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)?
	func getListStatus(data: [[String: String]]) async -> Result<ICreatePeerModels, Error>
}

struct CreateDirectMessageWorker {
	let channelStorage: IChannelStorage
	let remoteStore: ICreateDirectMessageRemoteStore
	let inMemoryStore: ICreateDirectMessageInMemoryStore
	var currentDomain: String?

	init(channelStorage: IChannelStorage,
		 remoteStore: ICreateDirectMessageRemoteStore,
		 inMemoryStore: ICreateDirectMessageInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension CreateDirectMessageWorker: ICreateDirectMessageWorker {
	func searchUser(keyword: String) async -> (Result<ICreatePeerModels, Error>) {
		let result = await remoteStore.searchUser(keyword: keyword, domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [CreatePeerUserViewModel]) async -> (Result<ICreatePeerModels, Error>) {
		return await remoteStore.createGroup(by: clientId, groupName: groupName, groupType: groupType, lstClient: lstClient, domain: currentDomain ?? channelStorage.currentDomain)
	}

	func getProfile() async -> Result<ICreatePeerModels, Error> {
		let result = await remoteStore.getProfile(domain: currentDomain ?? channelStorage.currentDomain)

		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getUserInfor(clientId: String, workspaceDomain: String) async -> (Result<ICreatePeerModels, Error>) {
		let result = await remoteStore.getUserProfile(clientId: clientId, workspaceDomain: workspaceDomain, domain: currentDomain ?? channelStorage.currentDomain)
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func searchUserWithEmail(email: String) async -> (Result<ICreatePeerModels, Error>) {
		let result = await remoteStore.searchUserWithEmail(keyword: email, domain: currentDomain ?? channelStorage.currentDomain)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getPeopleFromLink(link: String) -> (id: String, userName: String, domain: String)? {
		let args = link.split(separator: "/")
		if args.count != 3 {
			return nil
		}
		
		return (String(args[2]), String(args[1]), String(args[0]))
	}
	
	func checkPeopleLink(link: String) -> Bool {
		return self.getPeopleFromLink(link: link)?.id == channelStorage.currentServer?.profile?.userId
	}

	func getListStatus(data: [[String: String]]) async -> Result<ICreatePeerModels, Error> {
		let result = await remoteStore.getListStatus(domain: self.channelStorage.currentDomain, data: data)
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}

}
