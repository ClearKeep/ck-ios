//
//  ChatRemoteStore.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import ChatSecure
import Model
import CommonUI
import Common

protocol IChatRemoteStore {
	func getGroupById(domain: String, id: Int64) async -> Result<IGroupModel, Error>
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<[RealmMessage], Error>
	func sendMessageInGroup(senderId: String, ownerWorkspace: String, groupId: Int64, isJoined: Bool, plainMessage: String, cachedMessageId: Int, isForward: Bool) async -> Result<[RealmMessage], Error>
	func uploadFile(file: FileModel, isAppendSize: Bool, domain: String) async -> String?
	func downloadFile(urlString: String) async -> Result<String, Error>
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error>
}

struct ChatRemoteStore {
	let groupService: IGroupService
	let messageService: IMessageService
	let uploadFileService: IUploadFileService
	let callService: ICallService
}

extension ChatRemoteStore: IChatRemoteStore {
	
	func getGroupById(domain: String, id: Int64) async -> Result<IGroupModel, Error> {
		let result = await groupService.getGroup(by: id, domain: domain)
		
		switch result {
		case .success(let realmGroup):
			let group = GroupModel(realmGroup)
			return .success(group)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		let result = await messageService.getMessage(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, isGroup: isGroup, lastMessageAt: lastMessageAt)
		switch result {
		case .success(let realmMessage):
			return .success(realmMessage)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<[RealmMessage], Error> {
		let result = await messageService.sendMessageInPeer(senderId: senderId, ownerDomain: ownerWorkspace, receiverId: receiverId, receiverDomain: receiverWorkSpaceDomain, groupId: groupId, plainMessage: plainMessage, isForceProcessKey: isForceProcessKey, cachedMessageId: cachedMessageId)
		switch result {
		case .success(let realmMessage):
			print(realmMessage)
			return .success([realmMessage])
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func sendMessageInGroup(senderId: String, ownerWorkspace: String, groupId: Int64, isJoined: Bool, plainMessage: String, cachedMessageId: Int, isForward: Bool) async -> Result<[RealmMessage], Error> {
		let result = await messageService.sendMessageInGroup(senderId: senderId, ownerWorkspace: ownerWorkspace, groupId: groupId, isJoined: isJoined, plainMessage: plainMessage, cachedMessageId: cachedMessageId, isForward: isForward)
		switch result {
		case .success(let realmMessage):
			print(realmMessage)
			return .success([realmMessage])
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func uploadFile(file: FileModel, isAppendSize: Bool, domain: String) async -> String? {
		return await uploadFileService.uploadFile(mimeType: file.mimeType, fileName: file.name, fileURL: file.url, fileSize: file.size, isAppendSize: isAppendSize, domain: domain)
	}
	
	func downloadFile(urlString: String) async -> Result<String, Error> {
		return await uploadFileService.downloadFile(urlString: urlString)
	}
	
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error> {
		let response = await callService.requestVideoCall(groupID: groupId, isAudioMode: isAudioCall, serverDomain: domain)
		switch response {
		case .success(let data):
			let turnServer = data.turnServer
			return .success(CallServer(groupRtcUrl: data.groupRtcURL,
									   groupRtcId: data.groupRtcID,
									   groupRtcToken: data.groupRtcToken,
									   stunServer: StunServer(server: data.stunServer.server, port: data.stunServer.port),
									   turnServer: TurnServer(server: turnServer.server, port: turnServer.port, type: turnServer.type, user: turnServer.user, pwd: turnServer.pwd))
			)
		case .failure(let error):
			return .failure(error)
		}
	}
}
