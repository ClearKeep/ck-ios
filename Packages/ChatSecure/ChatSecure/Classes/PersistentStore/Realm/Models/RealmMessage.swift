//
//  RealmMessage.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift

class RealmMessage: Object, RealmOptionalType {
	@objc dynamic var generateId: Int
	@objc dynamic var messageId: String
	@objc dynamic var groupId: Int64
	@objc dynamic var groupType: String
	@objc dynamic var senderId: String
	@objc dynamic var receiverId: String
	@objc dynamic var message: String
	@objc dynamic var createdTime: Int64
	@objc dynamic var updatedTime: Int64
	@objc dynamic var ownerDomain: String
	@objc dynamic var ownerClientId: String
	
	override class func primaryKey() -> String? {
		return "generateId"
	}
	
	required override init() {
		generateId = Int()
		messageId = String()
		groupId = Int64()
		groupType = String()
		senderId = String()
		receiverId = String()
		message = String()
		createdTime = Int64()
		updatedTime = Int64()
		ownerDomain = String()
		ownerClientId = String()
		
		super.init()
	}
}
