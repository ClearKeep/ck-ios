//
//  RealmMessage.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift

public class RealmMessage: Object, RealmOptionalType {
	@objc public dynamic var generateId: Int
	@objc public dynamic var messageId: String
	@objc public dynamic var groupId: Int64
	@objc public dynamic var groupType: String
	@objc public dynamic var senderId: String
	@objc public dynamic var receiverId: String
	@objc public dynamic var message: String
	@objc public dynamic var createdTime: Int64
	@objc public dynamic var updatedTime: Int64
	@objc public dynamic var ownerDomain: String
	@objc public dynamic var ownerClientId: String
	
	public override class func primaryKey() -> String? {
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
