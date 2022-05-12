//
//  RealmServer.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift
	
class RealmServer: Object {
	@objc dynamic var generateId: Int
	@objc dynamic var serverName: String
	@objc dynamic var serverDomain: String
	@objc dynamic var ownerClientId: String
	@objc dynamic var serverAvatar: String
	@objc dynamic var loginTime: Int64
	@objc dynamic var accessKey: String
	@objc dynamic var hashKey: String
	@objc dynamic var refreshToken: String
	@objc dynamic var isActive: Bool
	@objc dynamic var profile: RealmProfile?
	
	public override class func primaryKey() -> String? {
		return "generateId"
	}
	
	required override init() {
		generateId = Int()
		serverName = String()
		serverDomain = String()
		ownerClientId = String()
		serverAvatar = String()
		loginTime = Int64()
		accessKey = String()
		hashKey = String()
		refreshToken = String()
		isActive = Bool()
		profile = nil
		
		super.init()
	}
}
