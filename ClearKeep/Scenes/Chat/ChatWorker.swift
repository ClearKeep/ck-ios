//
//  ChatWorker.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Model
import ChatSecure
import CommonUI

protocol IChatWorker {
	var remoteStore: IChatRemoteStore { get }
	var inMemoryStore: IChatInMemoryStore { get }
	
	func getGroupWithId(groupId: Int64) async -> Result<IGroupModel, Error>
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<[RealmMessage], Error>
}

struct ChatWorker {
	let channelStorage: IChannelStorage
	let remoteStore: IChatRemoteStore
	let inMemoryStore: IChatInMemoryStore
	
	init(channelStorage: IChannelStorage,
		remoteStore: IChatRemoteStore,
		 inMemoryStore: IChatInMemoryStore) {
		self.channelStorage = channelStorage
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChatWorker: IChatWorker {
	
	func getGroupWithId(groupId: Int64) async -> Result<IGroupModel, Error> {
		let domain = channelStorage.currentDomain
		let result = await remoteStore.getGroupById(domain: domain, id: groupId)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		let result = await remoteStore.getMessageList(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, lastMessageAt: lastMessageAt)
		
		switch result {
		case .success(let user):
			return .success(user)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<[RealmMessage], Error> {
		return await remoteStore.sendMessageInPeer(senderId: senderId, ownerWorkspace: ownerWorkspace, receiverId: receiverId, receiverWorkSpaceDomain: receiverWorkSpaceDomain, groupId: groupId, plainMessage: plainMessage, isForceProcessKey: isForceProcessKey, cachedMessageId: cachedMessageId)
	}
}
