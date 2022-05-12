//
//  RealmGroup.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift
	
public class RealmGroup: Object {
	@objc dynamic var generateId: Int
	@objc dynamic var groupId: Int64
	@objc dynamic var groupName: String
	@objc dynamic var groupAvatar: String
	@objc dynamic var groupType: String
	@objc dynamic var createdBy: String
	@objc dynamic var createdAt: Int64
	@objc dynamic var updatedBy: String
	@objc dynamic var updatedAt: Int64
	@objc dynamic var rtcToken: String
	dynamic var groupMembers: [RealmMember]
	@objc dynamic var isJoined: Bool
	@objc dynamic var ownerDomain: String
	@objc dynamic var ownerClientId: String
	@objc dynamic var lastMessage: RealmMessage?
	@objc dynamic var lastMessageAt: Int64
	@objc dynamic var lastMessageSyncTimestamp: Int64
	@objc dynamic var isDeletedUserPeer: Bool
	
	public override class func primaryKey() -> String? {
		return "generateId"
	}
	
	required override init() {
		generateId = Int()
		groupId = Int64()
		groupName = String()
		groupAvatar = String()
		groupType = String()
		createdBy = String()
		createdAt = Int64()
		updatedBy = String()
		updatedAt = Int64()
		rtcToken = String()
		groupMembers = [RealmMember]()
		isJoined = Bool()
		ownerDomain = String()
		ownerClientId = String()
		lastMessage = nil
		lastMessageAt = Int64()
		lastMessageSyncTimestamp = Int64()
		isDeletedUserPeer = Bool()
		
		super.init()
	}
}

class RealmMember: Object {
	@objc dynamic var userId: String
	@objc dynamic var userName: String
	@objc dynamic var domain: String
	@objc dynamic var userState: String
	@objc dynamic var userStatus: String
	@objc dynamic var phoneNumber: String
	@objc dynamic var avatar: String
	@objc dynamic var email: String
	
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
