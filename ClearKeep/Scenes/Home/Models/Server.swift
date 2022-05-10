//
//  Server.swift
//  ClearKeep
//
//  Created by NamNH on 10/05/2022.
//

import ChatSecure

struct Server: IServer {
	var id: Int?
	var serverName: String
	var serverDomain: String
	var ownerClientId: String
	var serverAvatar: String
	var loginTime: Int8
	var accessKey: String
	var hashKey: String
	var refreshToken: String
	var isActive: Bool
	var profile: IProfile
}
