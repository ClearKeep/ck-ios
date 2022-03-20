//
//  Profile.swift
//  
//
//  Created by NamNH on 11/03/2022.
//

import UIKit

public protocol IProfile {
	var generateId: Int? { get set }
	var userId: String { get set }
	var userName: String? { get set }
	var email: String? { get set }
	var phoneNumber: String? { get set }
	var updatedAt: Int8 { get set }
	var avatar: String? { get set }
}

struct Profile {
}
