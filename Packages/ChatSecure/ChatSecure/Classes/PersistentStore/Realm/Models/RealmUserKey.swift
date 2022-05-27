//
//  RealmUserKey.swift
//  ChatSecure
//
//  Created by Quang Pham on 07/06/2022.
//

import Foundation
import RealmSwift
	
public class RealmUserKey: Object {
	@objc public dynamic var generateId: Int
	@objc public dynamic var domain: String
	@objc public dynamic var clientId: String
	@objc public dynamic var salt: String
	@objc public dynamic var iv: String
	
	public override class func primaryKey() -> String? {
		return "generateId"
	}
	
	required override init() {
		generateId = Int()
		domain = String()
		clientId = String()
		salt = String()
		iv = String()
		super.init()
	}
}
