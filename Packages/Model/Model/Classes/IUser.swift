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

public protocol IGetUserResponse {
	var lstUser: [IUserInfoResponse] { get }
}

public protocol ISearchUserResponse {
	var lstUser: [IUserInfoResponse] { get }
}

public protocol IUserInfoResponse {
	var id: String { get }
	var displayName: String { get }
	var workspaceDomain: String { get }
}
