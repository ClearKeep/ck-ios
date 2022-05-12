//
//  RealmProfile.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift

class RealmProfile: Object {
	@objc dynamic var userId: String
	@objc dynamic var userName: String
	@objc dynamic var email: String
	@objc dynamic var phoneNumber: String
	@objc dynamic var updatedAt: Int64
	@objc dynamic var avatar: String
	
	required override init() {
		userId = String()
		userName = String()
		email = String()
		phoneNumber = String()
		updatedAt = Int64()
		avatar = String()
		
		super.init()
	}
}
