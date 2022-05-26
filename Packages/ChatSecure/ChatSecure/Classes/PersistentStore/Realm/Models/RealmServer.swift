//
//  RealmServer.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift
	
public class RealmServer: Object {
	@objc public dynamic var generateId: Int
	@objc public dynamic var serverName: String
	@objc public dynamic var serverDomain: String
	@objc public dynamic var ownerClientId: String
	@objc public dynamic var serverAvatar: String
	@objc public dynamic var loginTime: Int64
	@objc public dynamic var accessKey: String
	@objc public dynamic var hashKey: String
	@objc public dynamic var refreshToken: String
	@objc public dynamic var isActive: Bool
	@objc public dynamic var profile: RealmProfile?
	
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
