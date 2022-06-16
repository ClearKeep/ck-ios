//
//  ChatInteractor.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Common
import ChatSecure
import Networking
import Model

private enum Constants {
	static let loadSize = 20
}

protocol IChatInteractor {
	var worker: IChatWorker { get }
	func updateGroupWithId(groupId: Int64) async -> Loadable<IChatViewModels>
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels>
	func updateMessages(groupId: Int64, group: IGroupModel?, lastMessageAt: Int64) async -> Loadable<IChatViewModels>
}

struct ChatInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let groupService: IGroupService
	let messageService: IMessageService
}

extension ChatInteractor: IChatInteractor {
	
	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore(groupService: groupService, messageService: messageService)
		let inMemoryStore = ChatInMemoryStore()
		return ChatWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func updateGroupWithId(groupId: Int64) async -> Loadable<IChatViewModels> {
		let result = await worker.getGroupWithId(groupId: groupId)
		
		switch result {
		case .success(let group):
			let messagesResult = await getMessageList(groupId: groupId, loadSize: Constants.loadSize, lastMessageAt: 0)
			switch messagesResult {
			case .success(let message):
				return .loaded(ChatViewModels(responseGroup: group, responseMessage: message))
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func updateMessages(groupId: Int64, group: IGroupModel?, lastMessageAt: Int64) async -> Loadable<IChatViewModels> {
		guard let group = group else { return .loaded(ChatViewModels()) }
		let messagesResult = await getMessageList(groupId: groupId, loadSize: Constants.loadSize, lastMessageAt: lastMessageAt)
		switch messagesResult {
		case .success(let message):
			return .loaded(ChatViewModels(responseGroup: group, responseMessage: message))
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func getMessageList(groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return .failure(ServerError.unknown) }
		let result = await worker.getMessageList(ownerDomain: server.serverDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, lastMessageAt: lastMessageAt)
		return result
	}
	
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId,
			  let group = group
		else { return .loaded(ChatViewModels()) }
		let receiverUser = group.groupMembers.first { member in
			member.userId != ownerId
		}
		let result = await worker.sendMessageInPeer(senderId: ownerId, ownerWorkspace: server.serverDomain, receiverId: receiverUser?.userId ?? "", receiverWorkSpaceDomain: receiverUser?.domain ?? "", groupId: groupId, plainMessage: message, isForceProcessKey: isForceProcessKey, cachedMessageId: 0)
		switch result {
		case .success(let message):
			return .loaded(ChatViewModels(responseGroup: group, responseMessage: message))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubChatInteractor: IChatInteractor {
	let channelStorage: IChannelStorage
	let groupService: IGroupService
	let messageService: IMessageService

	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore(groupService: groupService, messageService: messageService)
		let inMemoryStore = ChatInMemoryStore()
		return ChatWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func updateGroupWithId(groupId: Int64) async -> Loadable<IChatViewModels> {
		return .notRequested
	}
	
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels> {
		return .notRequested
	}
	
	func updateMessages(groupId: Int64, group: IGroupModel?, lastMessageAt: Int64) async -> Loadable<IChatViewModels> {
		return .notRequested
	}
}
