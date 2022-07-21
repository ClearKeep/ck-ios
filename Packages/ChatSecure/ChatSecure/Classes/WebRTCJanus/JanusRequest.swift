//
//  JanusRequest.swift
//  ChatSecure
//
//  Created by Quang Pham on 21/07/2022.
//

import Foundation

struct CreateSessionRequest: Encodable {
	let janus: String = JanusMessage.create.rawValue
	let transaction: String
	let token: String
}

struct AttachPluginRequest: Encodable {
	let janus: String = JanusMessage.attach.rawValue
	let plugin: String?
	let transaction: String
	let sessionId: Int64
	let token: String
}

struct PublisherJoinRoomRequest: Encodable {
	
	struct Body: Encodable {
		var request = "join"
		var ptype = "publisher"
		var room: Int64
		var display: String
	}
	
	let janus = JanusMessage.message.rawValue
	let body: Body
	let transaction: String
	let sessionId: Int64
	let handleId: Int64
	let token: String
	
	init(room: Int64, sessionId: Int64, handleId: Int64, transaction: String, token: String, display: String) {
		self.sessionId = sessionId
		self.handleId = handleId
		self.transaction = transaction
		self.token = token
		self.body = Body(room: room, display: display)
	}
}
