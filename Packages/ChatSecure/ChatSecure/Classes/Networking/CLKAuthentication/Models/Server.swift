//
//  Server.swift
//  
//
//  Created by NamNH on 11/03/2022.
//

import Foundation
import Networking

protocol IServer {
	var serverName: String { get set }
	var serverDomain: String { get set }
	var ownerClientId: String { get set }
	var serverAvatar: String { get set }
	var loginTime: Int8 { get set }
	var accessKey: String { get set }
	var hashKey: String { get set }
	var refreshToken: String { get set }
	var isActive: Bool { get set }
	var profile: IProfile? { get set }
}

struct Server: IServer {
	var serverName: String
	var serverDomain: String
	var ownerClientId: String
	var serverAvatar: String
	var loginTime: Int8
	var accessKey: String
	var hashKey: String
	var refreshToken: String
	var isActive: Bool
	var profile: IProfile?
}

extension Server {
	init(clientId: String, authenResponse: Auth_AuthRes) {
		serverName = authenResponse.workspaceName
		serverDomain = authenResponse.workspaceDomain
		ownerClientId = clientId
		serverAvatar = ""
		loginTime = 0
		accessKey = authenResponse.accessToken
		hashKey = authenResponse.hashKey
		refreshToken = authenResponse.refreshToken
		isActive = false
	}
	
	init(profileResponse: User_UserProfileResponse, authenResponse: Auth_AuthRes) {
		serverName = authenResponse.workspaceName
		serverDomain = authenResponse.workspaceDomain
		ownerClientId = profileResponse.id
		serverAvatar = ""
		loginTime = 0
		accessKey = authenResponse.accessToken
		hashKey = authenResponse.hashKey
		refreshToken = authenResponse.refreshToken
		isActive = false
		profile = Profile(profileResponse: profileResponse)
	}
}
