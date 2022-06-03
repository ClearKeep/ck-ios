//
//  IUser.swift
//  Networking
//
//  Created by NamNH on 13/04/2022.
//

import Foundation

public protocol IUser {
	var id: String { get }
	var displayName: String { get }
	var email: String { get }
	var phoneNumber: String { get }
	var avatar: String { get }
}

public protocol IOwner {
	var clientId: String { get }
	var clientUserName: String { get }
	var domain: String { get }
}
