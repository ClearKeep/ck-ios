//
//  IGroupModel.swift
//  Model
//
//  Created by NamNH on 17/05/2022.
//

import Foundation

public protocol IGroupModel {
	var groupId: Int64 { get }
	var groupName: String { get }
	var groupAvatar: String { get set }
	var groupType: String { get }
	var createdBy: String { get }
	var createdAt: Int64 { get }
	var updatedBy: String { get }
	var updatedAt: Int64 { get }
	var rtcToken: String { get }
	var groupMembers: [IMemberModel] { get set }
	var isJoined: Bool { get }
	var ownerDomain: String { get }
	var ownerClientId: String { get }
	var lastMessage: IMessageModel? { get }
	var lastMessageAt: Int64 { get }
	var lastMessageSyncTimestamp: Int64 { get }
	var isDeletedUserPeer: Bool { get }
	var hasUnreadMessage: Bool { get }
}

public protocol IMemberModel {
	var userId: String { get }
	var userName: String { get }
	var domain: String { get }
	var userState: String { get }
	var userStatus: String { get }
	var phoneNumber: String { get }
	var avatar: String { get }
	var email: String { get }
}

public protocol IMessageModel {
	var messageId: String { get }
	var groupId: Int64 { get }
	var groupType: String { get }
	var senderId: String { get }
	var receiverId: String { get }
	var message: String { get }
	var createdTime: Int64 { get }
	var updatedTime: Int64 { get }
	var ownerDomain: String { get }
	var ownerClientId: String { get }
}
