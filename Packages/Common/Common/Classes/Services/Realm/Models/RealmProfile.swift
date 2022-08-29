//
//  RealmProfile.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift

public class RealmProfile: Object {
	@objc public dynamic var userId: String
	@objc public dynamic var userName: String
	@objc public dynamic var email: String
	@objc public dynamic var phoneNumber: String
	@objc public dynamic var updatedAt: Int64
	@objc public dynamic var avatar: String
	@objc public dynamic var isSocialAccount: Bool
	
	required override init() {
		userId = String()
		userName = String()
		email = String()
		phoneNumber = String()
		updatedAt = Int64()
		avatar = String()
		isSocialAccount = Bool()
		super.init()
	}
}
