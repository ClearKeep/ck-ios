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
import RealmSwift
import SwiftUI

private enum Constants {
	static let loadSize = 20
	static let maxImageCount = 10
	static let maxFilesizes = 1_000_000_000 // 1GB
}

protocol IChatInteractor {
	var worker: IChatWorker { get }
	func updateGroupWithId(loadable: LoadableSubject<IGroupModel>, groupId: Int64) async
	func sendMessageInPeer(loadable: LoadableSubject<IGroupModel>, message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async
	func updateMessages(loadable: LoadableSubject<IGroupModel>, isEndOfPage: Binding<Bool>, groupId: Int64, lastMessageAt: Int64) async
	func getJoinedGroupsFromLocal() async -> [IGroupModel]
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool
	func uploadFiles(loadable: LoadableSubject<IGroupModel>, message: String, fileURLs: [URL], group: IGroupModel?, appendFileSize: Bool, isForceProcessKey: Bool) async
	func downloadFile(urlString: String) async
	func getMessageFromLocal(groupId: Int64) -> Results<RealmMessage>?
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
	
	func updateGroupWithId(loadable: LoadableSubject<IGroupModel>, groupId: Int64) async {
		let cancelBag = CancelBag()
		loadable.wrappedValue.setIsLoading(cancelBag: cancelBag)
		
		let result = await worker.getGroupWithId(groupId: groupId)
		
		switch result {
		case .success(let group):
			let messagesResult = await getMessageList(groupId: groupId, loadSize: Constants.loadSize, lastMessageAt: 0)
			switch messagesResult {
			case .success(let message):
				print(message)
				loadable.wrappedValue = .loaded(group)
			case .failure(let error):
				loadable.wrappedValue = .failed(error)
			}
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
		}
	}
	
	func updateMessages(loadable: LoadableSubject<IGroupModel>, isEndOfPage: Binding<Bool>, groupId: Int64, lastMessageAt: Int64) async {
		let messagesResult = await getMessageList(groupId: groupId, loadSize: Constants.loadSize, lastMessageAt: lastMessageAt)
		switch messagesResult {
		case .success(let message):
			if message.count < 20 {
				isEndOfPage.wrappedValue = true
			}
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
		}
	}
	
	func getMessageList(groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return .failure(ServerError.unknown) }
		let result = await worker.getMessageList(ownerDomain: server.serverDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, lastMessageAt: lastMessageAt)
		return result
	}
	
	func sendMessageInPeer(loadable: LoadableSubject<IGroupModel>, message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId,
			  let group = group
		else {
			loadable.wrappedValue = .failed(ServerError.unknown)
			return
		}
		let receiverUser = group.groupMembers.first { member in
			member.userId != ownerId
		}
		let result = await worker.sendMessageInPeer(senderId: ownerId, ownerWorkspace: server.serverDomain, receiverId: receiverUser?.userId ?? "", receiverWorkSpaceDomain: receiverUser?.domain ?? "", groupId: groupId, plainMessage: message, isForceProcessKey: isForceProcessKey, cachedMessageId: 0)
		
		switch result {
		case .success(let message):
			print(message)
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
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
	
	func uploadFiles(loadable: LoadableSubject<IGroupModel>, message: String, fileURLs: [URL], group: IGroupModel?, appendFileSize: Bool, isForceProcessKey: Bool) async {
		if fileURLs.count > 10 {
			loadable.wrappedValue = .failed(ServerError.unknown)
			return
		}
		
		guard let filesInfo = processFileSizes(urls: fileURLs) else {
			loadable.wrappedValue = .failed(ServerError.unknown)
			return
		}
		
		guard let domain = channelStorage.currentServer?.serverDomain else {
			loadable.wrappedValue = .failed(ServerError.unknown)
			return
		}
		
		guard let messageContent = await worker.uploadFiles(message: message, files: filesInfo, domain: domain, appendFileSize: true) else {
			loadable.wrappedValue = .failed(ServerError.unknown)
			return
		}
		print(messageContent)
		await self.sendMessageInPeer(loadable: loadable, message: messageContent, groupId: group?.groupId ?? 0, group: group, isForceProcessKey: isForceProcessKey)
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
	
	func getMessageFromLocal(groupId: Int64) -> Results<RealmMessage>? {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return nil }
		return worker.getMessageFromLocal(groupId: groupId, ownerDomain: server.serverDomain, ownerId: ownerId)
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

	func updateGroupWithId(loadable: LoadableSubject<IGroupModel>, groupId: Int64) async {
	}
	
	func sendMessageInPeer(loadable: LoadableSubject<IGroupModel>, message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async {
	}
	
	func updateMessages(loadable: LoadableSubject<IGroupModel>, isEndOfPage: Binding<Bool>, groupId: Int64, lastMessageAt: Int64) async {
	}
	
	func getJoinedGroupsFromLocal() async -> [IGroupModel] {
		return []
	}
	
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool {
		return false
	}
	
	func uploadFiles(loadable: LoadableSubject<IGroupModel>, message: String, fileURLs: [URL], group: IGroupModel?, appendFileSize: Bool, isForceProcessKey: Bool) async {
	}
	
	func downloadFile(urlString: String) async {
		
	}
	
	func getMessageFromLocal(groupId: Int64) -> Results<RealmMessage>? {
		return nil
	}
}
