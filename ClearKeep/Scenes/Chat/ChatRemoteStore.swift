//
//  ChatRemoteStore.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import ChatSecure
import Model
import CommonUI

protocol IChatRemoteStore {
	func getGroupById(domain: String, id: Int64) async -> Result<IGroupModel, Error>
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<[RealmMessage], Error>
	func uploadFile(fileName: String, mimeType: String, fileURL: URL, domain: String) async -> String?
}

struct ChatRemoteStore {
	let groupService: IGroupService
	let messageService: IMessageService
	let uploadFileService: IUploadFileService
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
	
	func getMessageList(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		let result = await messageService.getMessage(ownerDomain: ownerDomain, ownerId: ownerId, groupId: groupId, loadSize: loadSize, lastMessageAt: lastMessageAt)
		switch result {
		case .success(let realmMessage):
			print(realmMessage)
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
	
	func uploadFile(fileName: String, mimeType: String, fileURL: URL, domain: String) async -> String? {
		return await uploadFileService.uploadFile(mimeType: mimeType, fileName: fileName, fileURL: fileURL, domain: domain)
	}
}
