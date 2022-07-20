//
//  ChatWorker.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Model
import ChatSecure
import CommonUI
import RealmSwift

protocol IChatWorker {
	var remoteStore: IChatRemoteStore { get }
	var inMemoryStore: IChatInMemoryStore { get }
	
	func getGroupWithId(groupId: Int64) async -> Result<IGroupModel, Error>
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<[RealmMessage], Error>
	func sendMessageInGroup(senderId: String, ownerWorkspace: String, groupId: Int64, isJoined: Bool, plainMessage: String, cachedMessageId: Int, isForward: Bool) async -> Result<[RealmMessage], Error>
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [IGroupModel]
	func uploadFiles(message: String, files: [FileModel], domain: String, appendFileSize: Bool) async -> String?
	func downloadFile(urlString: String) async -> Result<String, Error>
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>?
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error>
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
	
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		let result = await remoteStore.getMessageList(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, isGroup: isGroup, lastMessageAt: lastMessageAt)
		
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
	
	func sendMessageInGroup(senderId: String, ownerWorkspace: String, groupId: Int64, isJoined: Bool, plainMessage: String, cachedMessageId: Int, isForward: Bool) async -> Result<[RealmMessage], Error> {
		return await remoteStore.sendMessageInGroup(senderId: senderId, ownerWorkspace: ownerWorkspace, groupId: groupId, isJoined: isJoined, plainMessage: plainMessage, cachedMessageId: cachedMessageId, isForward: isForward)
	}
	
	func getJoinedGroupsFromLocal(ownerId: String, domain: String) async -> [IGroupModel] {
		let result = await inMemoryStore.getJoinedGroupsFromLocal(ownerId: ownerId, domain: domain)
		print(result)
		let groups = result.compactMap { group in
			GroupModel(group)
		}
		return groups
	}
	
	func uploadFiles(message: String, files: [FileModel], domain: String, appendFileSize: Bool) async -> String? {
		do {
			var fileUrlsString = ""
			try await withThrowingTaskGroup(of: String?.self, body: { taskGroup in
				for file in files {
					_ = taskGroup.addTaskUnlessCancelled {
						let result = await remoteStore.uploadFile(file: file, isAppendSize: appendFileSize, domain: domain)
						try Task.checkCancellation()
						return result
					}
				}
				
				for try await result in taskGroup {
					if let fileUrl = result {
						fileUrlsString.append("\(fileUrl) ")
					} else {
						taskGroup.cancelAll()
					}
				}
				fileUrlsString.append(message)
			})
			return fileUrlsString.trimmingCharacters(in: .whitespaces)
		} catch {
			return nil
		}
	}
	
	func getMessageFromLocal(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>? {
		return inMemoryStore.getMessageFromLocal(groupId: groupId, ownerDomain: ownerDomain, ownerId: ownerId)
	}
	
	func downloadFile(urlString: String) async -> Result<String, Error> {
		return await remoteStore.downloadFile(urlString: urlString)
	}
	
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error> {
		return await remoteStore.requestCall(groupId: groupId, isAudioCall: isAudioCall, domain: domain)
	}
}
