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
	static let keySaveTurnServerUser = "keySaveTurnServerUser"
	static let keySaveTurnServerPWD = "keySaveTurnServerPWD"
	static let keySaveTurnServer = "keySaveTurnServer"
	static let keySaveStunServer = "keySaveStunServer"
	static let keyDisplayname = "keyDisplayname"
}

protocol IChatInteractor {
	var worker: IChatWorker { get }
	func updateGroupWithId(groupId: Int64) async -> Loadable<IGroupModel?>
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<Void>
	func sendMessageInGroup(message: String, groupId: Int64, isJoined: Bool, isForward: Bool) async -> Loadable<Void>
	func updateMessages(loadable: LoadableSubject<IGroupModel?>, isEndOfPage: Binding<Bool>, groupId: Int64, isGroup: Bool, lastMessageAt: Int64) async
	func getJoinedGroupsFromLocal() async -> [IGroupModel]
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool
	func forwardGroupMessage(message: String, groupId: Int64, isJoined: Bool) async -> Bool
	func uploadFiles(message: String, fileURLs: [URL], group: IGroupModel?, appendFileSize: Bool, isForceProcessKey: Bool) async -> Loadable<Void>
	func downloadFile(urlString: String) async
	func getMessageFromLocal(groupId: Int64) -> Results<RealmMessage>?
	func requestVideoCall(isCallGroup: Bool, clientId: String, clientName: String, avatar: String, groupId: Int64, callType type: CallType) async -> Result<Bool, Error>
	func saveDraftMessage(message: String, roomId: Int64)
	func getDraftMessage(roomId: Int64) -> String?
}

struct ChatInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let realmManager: RealmManager
	let groupService: IGroupService
	let messageService: IMessageService
	let uploadFileService: IUploadFileService
	let callService: ICallService
	let clientStore: ClientStore
}

extension ChatInteractor: IChatInteractor {
	
	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore(groupService: groupService, messageService: messageService, uploadFileService: uploadFileService, callService: callService)
		let inMemoryStore = ChatInMemoryStore(realmManager: realmManager, clientStore: clientStore)
		return ChatWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func updateGroupWithId(groupId: Int64) async -> Loadable<IGroupModel?> {
		let result = await worker.getGroupWithId(groupId: groupId)
		
		switch result {
		case .success(let group):
			let isGroup = group.groupType == "group"
			let messagesResult = await getMessageList(groupId: groupId, loadSize: Constants.loadSize, isGroup: isGroup, lastMessageAt: 0)
			switch messagesResult {
			case .success(let message):
				print(message)
				return .loaded(group)
			case .failure(let error):
				return .failed(error)
			}
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func updateMessages(loadable: LoadableSubject<IGroupModel?>, isEndOfPage: Binding<Bool>, groupId: Int64, isGroup: Bool, lastMessageAt: Int64) async {
		let messagesResult = await getMessageList(groupId: groupId, loadSize: Constants.loadSize, isGroup: isGroup, lastMessageAt: lastMessageAt)
		switch messagesResult {
		case .success(let message):
			if message.count < 20 {
				isEndOfPage.wrappedValue = true
			}
		case .failure(let error):
			loadable.wrappedValue = .failed(error)
		}
	}
	
	func getMessageList(groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return .failure(ServerError.unknown) }
		let result = await worker.getMessageList(ownerDomain: server.serverDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, isGroup: isGroup, lastMessageAt: lastMessageAt)
		return result
	}
	
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<Void> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId,
			  let group = group
		else {
			return .failed(ServerError.unknown)
		}
		let receiverUser = group.groupMembers.first { member in
			member.userId != ownerId
		}
		let result = await worker.sendMessageInPeer(senderId: ownerId, ownerWorkspace: server.serverDomain, receiverId: receiverUser?.userId ?? "", receiverWorkSpaceDomain: receiverUser?.domain ?? "", groupId: groupId, plainMessage: message, isForceProcessKey: isForceProcessKey, cachedMessageId: 0)
		
		switch result {
		case .success(let message):
			print(message)
			return .loaded(())
		case .failure(let error):
			return .failed(error)
		}
	}
	
	func sendMessageInGroup(message: String, groupId: Int64, isJoined: Bool, isForward: Bool) async -> Loadable<Void> {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId
		else {
			return .failed(ServerError.unknown)
		}
		let result = await worker.sendMessageInGroup(senderId: ownerId, ownerWorkspace: server.serverDomain, groupId: groupId, isJoined: isJoined, plainMessage: message, cachedMessageId: 0, isForward: isForward)
		
		switch result {
		case .success(let message):
			print(message)
			return .loaded(())
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
	
	func forwardGroupMessage(message: String, groupId: Int64, isJoined: Bool) async -> Bool {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId
		else { return false }
		let result = await worker.sendMessageInGroup(senderId: ownerId, ownerWorkspace: server.serverDomain, groupId: groupId, isJoined: isJoined, plainMessage: message, cachedMessageId: 0, isForward: true)
		switch result {
		case .success(let value):
			print(value)
			return true
		case .failure(let error):
			print(error)
			return false
		}
	}
	
	func uploadFiles(message: String, fileURLs: [URL], group: IGroupModel?, appendFileSize: Bool, isForceProcessKey: Bool) async -> Loadable<Void> {
		if fileURLs.count > 10 {
			return .failed(ChatError.fileLimit)
		}
		
		guard let filesInfo = processFileSizes(urls: fileURLs) else {
			return .failed(ChatError.fileSize)
		}
		
		guard let domain = channelStorage.currentServer?.serverDomain else {
			return .failed(ServerError.unknown)
		}
		
		guard let messageContent = await worker.uploadFiles(message: message, files: filesInfo, domain: domain, appendFileSize: appendFileSize) else {
			return .failed(ServerError.unknown)
		}
		print(messageContent)
		if group?.groupType == "group" {
			let isJoined = group?.isJoined ?? false
			return await self.sendMessageInGroup(message: messageContent, groupId: group?.groupId ?? 0, isJoined: isJoined, isForward: false)
		} else {
			return await self.sendMessageInPeer(message: messageContent, groupId: group?.groupId ?? 0, group: group, isForceProcessKey: isForceProcessKey)
		}
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
	
	func requestVideoCall(isCallGroup: Bool, clientId: String, clientName: String, avatar: String, groupId: Int64, callType type: CallType = .audio) async -> Result<Bool, Error> {
		guard let domain = channelStorage.currentServer?.serverDomain else { return .success(false) }
		let result = await worker.requestCall(groupId: groupId, isAudioCall: type == .audio, domain: domain)
		switch result {
		case .success(let data):
			UserDefaults.standard.setValue(data.turnServer.user, forKey: Constants.keySaveTurnServerUser)
			UserDefaults.standard.setValue(data.turnServer.pwd, forKey: Constants.keySaveTurnServerPWD)
			UserDefaults.standard.setValue(data.turnServer.server, forKey: Constants.keySaveTurnServer)
			UserDefaults.standard.setValue(data.stunServer.server, forKey: Constants.keySaveStunServer)
			UserDefaults.standard.setValue(DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "", forKey: Constants.keyDisplayname)
			UserDefaults.standard.synchronize()
			CallManager.shared.startCall(clientId: clientId,
										 clientName: clientName,
										 avatar: avatar,
										 groupId: data.groupRtcId,
										 groupRtcId: groupId,
										 groupToken: data.groupRtcToken,
										 callType: type,
										 isCallGroup: isCallGroup,
										 groupRtcUrl: data.groupRtcUrl)
			return .success(true)
		case .failure(let error):
			print(error)
			return .failure(error)
		}
	}
	
	func saveDraftMessage(message: String, roomId: Int64) {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return }
		worker.saveDraftMessage(message: message, roomId: roomId, clientId: ownerId, domain: server.serverDomain)
	}
	
	func getDraftMessage(roomId: Int64) -> String? {
		guard let server = channelStorage.currentServer,
			  let ownerId = server.profile?.userId else { return nil }
		return worker.getDraftMessage(roomId: roomId, clientId: ownerId, domain: server.serverDomain)
	}
}

struct StubChatInteractor: IChatInteractor {
	let channelStorage: IChannelStorage
	let groupService: IGroupService
	let messageService: IMessageService
	let uploadFileService: IUploadFileService
	let realmManager: RealmManager
	let callService: ICallService
	let clientStore: ClientStore
	
	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore(groupService: groupService, messageService: messageService, uploadFileService: uploadFileService, callService: callService)
		let inMemoryStore = ChatInMemoryStore(realmManager: realmManager, clientStore: clientStore)
		return ChatWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func updateGroupWithId(groupId: Int64) async -> Loadable<IGroupModel?> {
		return .notRequested
	}
	
	func sendMessageInPeer(message: String, groupId: Int64, group: IGroupModel?, isForceProcessKey: Bool) async -> Loadable<Void> {
		return .notRequested
	}
	
	func sendMessageInGroup(message: String, groupId: Int64, isJoined: Bool, isForward: Bool) async -> Loadable<Void> {
		return .notRequested
	}
	
	func updateMessages(loadable: LoadableSubject<IGroupModel?>, isEndOfPage: Binding<Bool>, groupId: Int64, isGroup: Bool, lastMessageAt: Int64) async {
	}
	
	func getJoinedGroupsFromLocal() async -> [IGroupModel] {
		return []
	}
	
	func forwardPeerMessage(message: String, group: IGroupModel) async -> Bool {
		return false
	}
	
	func uploadFiles(message: String, fileURLs: [URL], group: IGroupModel?, appendFileSize: Bool, isForceProcessKey: Bool) async -> Loadable<Void> {
		return .notRequested
	}
	
	func downloadFile(urlString: String) async {
		
	}
	
	func getMessageFromLocal(groupId: Int64) -> Results<RealmMessage>? {
		return nil
	}
	
	func requestVideoCall(isCallGroup: Bool, clientId: String, clientName: String, avatar: String, groupId: Int64, callType type: CallType = .audio) async -> Result<Bool, Error> {
		return .success(true)
	}
	
	func forwardGroupMessage(message: String, groupId: Int64, isJoined: Bool) async -> Bool {
		return false
	}
	
	func saveDraftMessage(message: String, roomId: Int64) {
		
	}
	
	func getDraftMessage(roomId: Int64) -> String? {
		return nil
	}
}
