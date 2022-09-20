//
//  GroupDetailViewModel.swift
//  ClearKeep
//
//  Created by MinhDev on 23/06/2022.
//

import Model
import ChatSecure

struct GroupDetailViewModel {
	var groupId: Int64
	var groupName: String
	var groupAvatar: String
	var groupType: String
	var createdBy: String
	var createdAt: Int64
	var updatedBy: String
	var updatedAt: Int64
	var rtcToken: String
	var groupMembers: [GroupDetailClientViewModel]
	var isJoined: Bool
	var ownerDomain: String
	var ownerClientId: String
	var lastMessageAt: Int64
	var lastMessageSyncTimestamp: Int64
	var isDeletedUserPeer: Bool
	var hasUnreadMessage: Bool
}

extension GroupDetailViewModel {
	init(_ realmGroup: IGroupModel?) {
		let groupMembers = realmGroup?.groupMembers.map { member in
			GroupDetailClientViewModel(member: member)
		}
		self.init(groupId: realmGroup?.groupId ?? 0,
				  groupName: realmGroup?.groupName ?? "",
				  groupAvatar: realmGroup?.groupAvatar ?? "",
				  groupType: realmGroup?.groupType ?? "",
				  createdBy: realmGroup?.createdBy ?? "",
				  createdAt: realmGroup?.createdAt ?? 0,
				  updatedBy: realmGroup?.updatedBy ?? "",
				  updatedAt: realmGroup?.updatedAt ?? 0,
				  rtcToken: realmGroup?.rtcToken ?? "",
				  groupMembers: groupMembers ?? [],
				  isJoined: realmGroup?.isJoined ?? false,
				  ownerDomain: realmGroup?.ownerDomain ?? "",
				  ownerClientId: realmGroup?.ownerClientId ?? "",
				  lastMessageAt: realmGroup?.lastMessageAt ?? 0,
				  lastMessageSyncTimestamp: realmGroup?.lastMessageSyncTimestamp ?? 0,
				  isDeletedUserPeer: realmGroup?.isDeletedUserPeer ?? false,
				  hasUnreadMessage: realmGroup?.hasUnreadMessage ?? false)
	}
}

struct GroupDetailClientViewModel: Identifiable {
	var id: String
	var userName: String
	var domain: String
	var userState: String
	var userStatus: StatusType
	var phoneNumber: String
	var avatar: String
	var email: String
}

extension GroupDetailClientViewModel {
	init(member: IMemberModel) {
		self.init(id: member.userId,
				  userName: member.userName,
				  domain: member.domain,
				  userState: member.userState,
				  userStatus: StatusType(rawValue: member.userStatus) ?? .undefined,
				  phoneNumber: member.phoneNumber,
				  avatar: member.avatar,
				  email: member.email)
	}

	init() {
		self.id = ""
		self.userName = ""
		self.domain = ""
		self.userState = ""
		self.userStatus = .undefined
		self.phoneNumber = ""
		self.avatar = ""
		self.email = ""
	}
}
