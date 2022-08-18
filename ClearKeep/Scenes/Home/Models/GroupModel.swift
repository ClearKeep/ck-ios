//
//  GroupModel.swift
//  ClearKeep
//
//  Created by NamNH on 17/05/2022.
//

import Model
import ChatSecure

struct GroupModel: IGroupModel {
	var groupId: Int64 = 0
	var groupName: String = ""
	var groupAvatar: String = ""
	var groupType: String = ""
	var createdBy: String = ""
	var createdAt: Int64 = 0
	var updatedBy: String = ""
	var updatedAt: Int64 = 0
	var rtcToken: String = ""
	var groupMembers: [IMemberModel]
	var isJoined: Bool = false
	var ownerDomain: String = ""
	var ownerClientId: String = ""
	var lastMessage: IMessageModel? = nil
	var lastMessageAt: Int64 = 0
	var lastMessageSyncTimestamp: Int64 = 0
	var isDeletedUserPeer: Bool = false
	var hasUnreadMessage: Bool = false
}

extension GroupModel {
	
	init(groupMembers: [IMemberModel]?) {
		self.groupMembers = groupMembers ?? []
	}
	
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
