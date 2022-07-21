//
//  CallServer.swift
//  ClearKeep
//
//  Created by Quang Pham on 21/07/2022.
//

import Foundation

public struct StunServer {
	let server: String
	let port: Int64
	
	public init(server: String, port: Int64) {
		self.server = server
		self.port = port
	}
}

public struct TurnServer {
	let server: String
	let port: Int64
	let type: String
	let user: String
	let pwd: String
	
	public init(server: String, port: Int64, type: String, user: String, pwd: String) {
		self.server = server
		self.port = port
		self.type = type
		self.user = user
		self.pwd = pwd
	}
}

public struct CallServer {
	let groupRtcUrl: String
	let groupRtcId: Int64
	let groupRtcToken: String
	let stunServer: StunServer
	let turnServer: TurnServer
	
	public init(groupRtcUrl: String, groupRtcId: Int64, groupRtcToken: String, stunServer: StunServer, turnServer: TurnServer) {
		self.groupRtcUrl = groupRtcUrl
		self.groupRtcId = groupRtcId
		self.groupRtcToken = groupRtcToken
		self.stunServer = stunServer
		self.turnServer = turnServer
	}
}
