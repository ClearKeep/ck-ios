//
//  CallServer.swift
//  ClearKeep
//
//  Created by Quang Pham on 21/07/2022.
//

import Foundation

public struct StunServer {
	public let server: String
	public let port: Int64
	
	public init(server: String, port: Int64) {
		self.server = server
		self.port = port
	}
}

public struct TurnServer {
	public let server: String
	public let port: Int64
	public let type: String
	public let user: String
	public let pwd: String
	
	public init(server: String, port: Int64, type: String, user: String, pwd: String) {
		self.server = server
		self.port = port
		self.type = type
		self.user = user
		self.pwd = pwd
	}
}

public struct CallServer {
	public let groupRtcUrl: String
	public let groupRtcId: Int64
	public let groupRtcToken: String
	public let stunServer: StunServer
	public let turnServer: TurnServer
	
	public init(groupRtcUrl: String, groupRtcId: Int64, groupRtcToken: String, stunServer: StunServer, turnServer: TurnServer) {
		self.groupRtcUrl = groupRtcUrl
		self.groupRtcId = groupRtcId
		self.groupRtcToken = groupRtcToken
		self.stunServer = stunServer
		self.turnServer = turnServer
	}
}
