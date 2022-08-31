//
//  ServerModel.swift
//  ClearKeep
//
//  Created by NamNH on 17/05/2022.
//

import Model
import Common

struct ServerModel: Equatable, IServerModel {
	var serverName: String
	var serverDomain: String
	var ownerClientId: String
	var serverAvatar: String
	var loginTime: Int64
	var accessKey: String
	var hashKey: String
	var refreshToken: String
	var isActive: Bool
	var profile: IProfileModel?
	
	static func == (lhs: ServerModel, rhs: ServerModel) -> Bool {
		return lhs.serverDomain == rhs.serverDomain
	}
}

extension ServerModel {
	init?(_ server: RealmServer?) {
		guard let server = server else {
			return nil
		}
		self.init(serverName: server.serverName,
				  serverDomain: server.serverDomain,
				  ownerClientId: server.ownerClientId,
				  serverAvatar: server.serverAvatar,
				  loginTime: server.loginTime,
				  accessKey: server.accessKey,
				  hashKey: server.hashKey,
				  refreshToken: server.refreshToken,
				  isActive: server.isActive)
	}
	
}
