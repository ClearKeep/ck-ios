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
import CommonUI

private enum Constants {
	static let loadSize = 20
	static let maxImageCount = 10
	static let maxFilesizes = 1_000_000_000 // 1GB
}

protocol IChatInteractor {
	var worker: IChatWorker { get }
	func updateGroupWithId(groupId: Int64) async -> Loadable<IChatViewModels>
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels>
	func updateMessages(groupId: Int64, group: IGroupModel?, lastMessageAt: Int64) async -> Loadable<IChatViewModels>
	func getJoinedGroupsFromLocal() async -> [IGroupModel]
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool
	func uploadFiles(message: String, fileURLs: [URL], group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels>
	func downloadFile(urlString: String) async
}

struct ChatInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let realmManager: RealmManager
	let groupService: IGroupService
	let messageService: IMessageService
	let uploadFileService: IUploadFileService
}

extension ChatInteractor: IChatInteractor {
	
	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore(groupService: groupService, messageService: messageService, uploadFileService: uploadFileService)
		let inMemoryStore = ChatInMemoryStore(realmManager: realmManager)
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
	
	func getJoinedGroupsFromLocal() async -> [IGroupModel] {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId
		else { return [] }
		return await worker.getJoinedGroupsFromLocal(ownerId: ownerId, domain: server.serverDomain)
	}
	
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId
		else { return false }
		let receiverUser = group.groupMembers.first { member in
			member.userId != ownerId
		}
		let result = await worker.sendMessageInPeer(senderId: ownerId, ownerWorkspace: server.serverDomain, receiverId: receiverUser?.userId ?? "", receiverWorkSpaceDomain: receiverUser?.domain ?? "", groupId: group.groupId, plainMessage: message, isForceProcessKey: false, cachedMessageId: 0)
		switch result {
		case .success(let value):
			print(value)
			return true
		case .failure(let error):
			print(error)
			return false
		}
	}
	
	func uploadFiles(message: String, fileURLs: [URL], group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels> {
		if fileURLs.count > 10 {
			return .failed(ServerError.unknown)
		}
		
		guard let filesInfo = processFileSizes(urls: fileURLs) else { return .failed(ServerError.unknown) }
		guard let domain = channelStorage.currentServer?.serverDomain else { return .failed(ServerError.unknown) }
		
		guard let messageContent = await worker.uploadFiles(message: message, files: filesInfo, domain: domain, appendFileSize: true) else { return .failed(ServerError.unknown) }
		print(messageContent)
		return await self.sendMessageInPeer(message: messageContent, groupId: group?.groupId ?? 0, group: group, isForceProcessKey: isForceProcessKey)
	}
	
	func downloadFile(urlString: String) async {
		_ = await worker.downloadFile(urlString: MessageUtils.getFileDownloadURL(content: urlString))
	}
	
	private func processFileSizes(urls: [URL]) -> [FileModel]? {
		do {
			var totalFileSize: Int64 = 0
			var filesInfo = [FileModel]()
			try urls.forEach { url in
				_ = url.startAccessingSecurityScopedResource()
				let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
				let size = attributes[.size] as? Int64 ?? 0
				filesInfo.append(FileModel(url: url, size: size))
				totalFileSize += size
			}
			return totalFileSize < Constants.maxFilesizes ? filesInfo : nil
		} catch {
			return nil
		}
	}
	
}

struct StubChatInteractor: IChatInteractor {
	
	let channelStorage: IChannelStorage
	let groupService: IGroupService
	let messageService: IMessageService
	let uploadFileService: IUploadFileService
	let realmManager: RealmManager

	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore(groupService: groupService, messageService: messageService, uploadFileService: uploadFileService)
		let inMemoryStore = ChatInMemoryStore(realmManager: realmManager)
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
	
	func getJoinedGroupsFromLocal() async -> [IGroupModel] {
		return []
	}
	
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool {
		return false
	}
	
	func uploadFiles(message: String, fileURLs: [URL], group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels> {
		return .notRequested
	}
	
	func downloadFile(urlString: String) async {
		
	}
	
	func uploadFiles(message: String, filesUrl: [URL], group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<IChatViewModels> {
		return .notRequested
	}
}
