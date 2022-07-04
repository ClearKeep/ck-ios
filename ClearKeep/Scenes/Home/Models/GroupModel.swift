//
//  GroupModel.swift
//  ClearKeep
//
//  Created by NamNH on 17/05/2022.
//

import Model
import ChatSecure

struct GroupModel: IGroupModel {
	var groupId: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var createdBy: String
	var createdAt: Int64
	var updatedBy: String
	var updatedAt: Int64
	var rtcToken: String
	var groupMembers: [IMemberModel]
	var isJoined: Bool
	var ownerDomain: String
	var ownerClientId: String
	var lastMessage: IMessageModel?
	var lastMessageAt: Int64
	var lastMessageSyncTimestamp: Int64
	var isDeletedUserPeer: Bool
	var hasUnreadMessage: Bool
}

extension GroupModel {
	init(_ realmGroup: RealmGroup) {
		let groupMembers = realmGroup.groupMembers.lazyList.map({ MemberModel($0) })
		
		self.init(groupId: realmGroup.groupId,
				  groupName: realmGroup.groupName,
				  groupAvatar: realmGroup.groupAvatar,
				  groupType: realmGroup.groupType,
				  createdBy: realmGroup.createdBy,
				  createdAt: realmGroup.createdAt,
				  updatedBy: realmGroup.updatedBy,
				  updatedAt: realmGroup.updatedAt,
				  rtcToken: realmGroup.rtcToken,
				  groupMembers: groupMembers,
				  isJoined: realmGroup.isJoined,
				  ownerDomain: realmGroup.ownerDomain,
				  ownerClientId: realmGroup.ownerClientId,
				  lastMessageAt: realmGroup.lastMessageAt,
				  lastMessageSyncTimestamp: realmGroup.lastMessageSyncTimestamp,
				  isDeletedUserPeer: realmGroup.isDeletedUserPeer,
				  hasUnreadMessage: realmGroup.hasUnreadMessage)
	}
}

struct MemberModel: IMemberModel {
	var userId: String
	var userName: String
	var domain: String
	var userState: String
	var userStatus: String
	var phoneNumber: String
	var avatar: String
	var email: String
}

extension MemberModel {
	init(_ member: RealmMember) {
		self.init(userId: member.userId,
				  userName: member.userName,
				  domain: member.domain,
				  userState: member.userState,
				  userStatus: member.userStatus,
				  phoneNumber: member.phoneNumber,
				  avatar: member.avatar,
				  email: member.email)
	}
}

struct MessageModel: IMessageModel {
	var messageId: String
	var groupId: Int64
	var groupType: String
	var senderId: String
	var receiverId: String
	var message: String
	var createdTime: Int64
	var updatedTime: Int64
	var ownerDomain: String
	var ownerClientId: String
}

extension MessageModel {
	init(_ message: RealmMessage) {
		self.init(messageId: message.messageId,
				  groupId: message.groupId,
				  groupType: message.groupType,
				  senderId: message.senderId,
				  receiverId: message.receiverId,
				  message: message.message,
				  createdTime: message.createdTime,
				  updatedTime: message.updatedTime,
				  ownerDomain: message.ownerDomain,
				  ownerClientId: message.ownerClientId)
	}
}
