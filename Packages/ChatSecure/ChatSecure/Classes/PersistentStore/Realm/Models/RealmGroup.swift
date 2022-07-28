//
//  RealmGroup.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift
	
public class RealmGroup: Object {
	@objc public dynamic var generateId: String
	@objc public dynamic var groupId: Int64
	@objc public dynamic var groupName: String
	@objc public dynamic var groupAvatar: String
	@objc public dynamic var groupType: String
	@objc public dynamic var createdBy: String
	@objc public dynamic var createdAt: Int64
	@objc public dynamic var updatedBy: String
	@objc public dynamic var updatedAt: Int64
	@objc public dynamic var rtcToken: String
	public let groupMembers = List<RealmMember>()
	@objc public dynamic var isJoined: Bool
	@objc public dynamic var ownerDomain: String
	@objc public dynamic var ownerClientId: String
	@objc public dynamic var lastMessage: RealmMessage?
	@objc public dynamic var lastMessageAt: Int64
	@objc public dynamic var lastMessageSyncTimestamp: Int64
	@objc public dynamic var isDeletedUserPeer: Bool
	@objc public dynamic var hasUnreadMessage: Bool
	
	public override class func primaryKey() -> String? {
		return "generateId"
	}
	
	required override init() {
		generateId = String()
		groupId = Int64()
		groupName = String()
		groupAvatar = String()
		groupType = String()
		createdBy = String()
		createdAt = Int64()
		updatedBy = String()
		updatedAt = Int64()
		rtcToken = String()
		isJoined = Bool()
		ownerDomain = String()
		ownerClientId = String()
		lastMessage = nil
		lastMessageAt = Int64()
		lastMessageSyncTimestamp = Int64()
		isDeletedUserPeer = Bool()
		hasUnreadMessage = Bool()
		
		super.init()
	}
}

public class RealmMember: Object {
	@objc public dynamic var userId: String
	@objc public dynamic var userName: String
	@objc public dynamic var domain: String
	@objc public dynamic var userState: String
	@objc public dynamic var userStatus: String
	@objc public dynamic var phoneNumber: String
	@objc public dynamic var avatar: String
	@objc public dynamic var email: String
	
	required override init() {
		userId = String()
		userName = String()
		domain = String()
		userState = String()
		userStatus = String()
		phoneNumber = String()
		avatar = String()
		email = String()
		
		super.init()
	}
}
