//
//  IUser.swift
//  Networking
//
//  Created by NamNH on 13/04/2022.
//

import Foundation

public protocol IUser {
	var id: String { get }
	var name: String { get }
}

public protocol IOwner {
	var clientId: String { get }
	var domain: String { get }
}
