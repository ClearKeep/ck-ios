//
//  CreatGroupModel.swift
//  ClearKeep
//
//  Created by MinhDev on 09/06/2022.
//

import Model
import ChatSecure
import Networking

struct CreatGroupModel: IGroupResponseModel {
	var groupID: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var lstClient: [IClientInGroupModel]
	var lastMessageAt: Int64
	var lastMessage: IGroupMessageResponse
	var hasLastMessage: Bool
	var createdByClientID: String
	var createdAt: Int64
	var updatedByClientID: String
	var updatedAt: Int64
	var groupRtcToken: String
	var hasUnreadMessage: Bool
	var clientKey: IGroupClientKey
	var hasClientKey: Bool
}

extension CreatGroupModel {
	init(_ responseGroup: Group_GroupObjectResponse) {
		let groupMembers = responseGroup.lstClient.map { member in
			ClientInGroupModel(member)
		}
		let lastMessage = GroupMessageResponse(responseGroup.lastMessage)
		let clientKey = GroupClientKey(responseGroup.clientKey)
		
		self.init(groupID: responseGroup.groupID,
				  groupName: responseGroup.groupName,
				  groupAvatar: responseGroup.groupAvatar,
				  groupType: responseGroup.groupType,
				  lstClient: groupMembers,
				  lastMessageAt: responseGroup.lastMessageAt,
				  lastMessage: lastMessage,
				  hasLastMessage: responseGroup.hasLastMessage,
				  createdByClientID: responseGroup.createdByClientID,
				  createdAt: responseGroup.createdAt,
				  updatedByClientID: responseGroup.updatedByClientID,
				  updatedAt: responseGroup.updatedAt,
				  groupRtcToken: responseGroup.groupRtcToken,
				  hasUnreadMessage: responseGroup.hasUnreadMessage_p,
				  clientKey: clientKey,
				  hasClientKey: responseGroup.hasClientKey)
	}
}

struct ClientInGroupModel: IClientInGroupModel {
	var id: String
	var displayName: String
	var workspaceDomain: String
}

extension ClientInGroupModel {
	init(_ member: Group_ClientInGroupResponse) {
		self.init(id: member.id,
				  displayName: member.displayName,
				  workspaceDomain: member.workspaceDomain)
	}
}

struct GroupMessageResponse: IGroupMessageResponse {
	var id: String
	var groupID: Int64
	var groupType: String
	var fromClientID: String
	var clientID: String
	var message: Data
	var lstClientRead: [IGroupClientRead]
	var createdAt: Int64
	var updatedAt: Int64
	var senderMessage: Data
}

extension GroupMessageResponse {
	init(_ message: Group_MessageObjectResponse) {
		let lstClientRead = message.lstClientRead.map { member in
			GroupClientRead(member)
		}
		
		self.init(id: message.id,
				  groupID: message.groupID,
				  groupType: message.groupType,
				  fromClientID: message.fromClientID,
				  clientID: message.clientID,
				  message: message.message,
				  lstClientRead: lstClientRead,
				  createdAt: message.createdAt,
				  updatedAt: message.updatedAt,
				  senderMessage: message.senderMessage)
	}
}

struct GroupClientRead: IGroupClientRead {
	var id: String
	var displayName: String
	var avatar: String
}

extension GroupClientRead {
	init(_ groupClient: Group_ClientReadObject) {
		self.init(id: groupClient.id,
				  displayName: groupClient.displayName,
				  avatar: groupClient.avatar)
	}
}

struct GroupClientKey: IGroupClientKey {
	var workspaceDomain: String
	var clientID: String
	var deviceID: Int32
	var clientKeyDistribution: Data
	var senderKeyID: Int64
	var senderKey: Data
	var publicKey: Data
	var privateKey: String
}

extension GroupClientKey {
	init(_ groupKey: Group_GroupClientKeyObject) {
		self.init(workspaceDomain: groupKey.workspaceDomain,
				  clientID: groupKey.clientID,
				  deviceID: groupKey.deviceID,
				  clientKeyDistribution: groupKey.clientKeyDistribution,
				  senderKeyID: groupKey.senderKeyID,
				  senderKey: groupKey.senderKey,
				  publicKey: groupKey.publicKey,
				  privateKey: groupKey.privateKey)
	}
}

struct GroupBaseResponse: IGroupBaseResponse {
	var error: String
}

extension GroupBaseResponse {
	init(_ errorGroup: Group_BaseResponse) {
		self.init(error: errorGroup.error)
	}
}
