//
//  JanusRequest.swift
//  ChatSecure
//
//  Created by Quang Pham on 21/07/2022.
//

import WebRTC

struct CreateSessionRequest: Encodable {
	let janus: String = JanusMessage.create.rawValue
	let transaction: String
	let token: String
}

struct AttachPluginRequest: Encodable {
	let janus: String = JanusMessage.attach.rawValue
	let plugin: String?
	let transaction: String
	let session_id: Int64
	let token: String
}

struct DetachPluginRequest: Encodable {
	let janus = JanusMessage.detach.rawValue
	let handle_id: Int64
	let session_id: Int64
	let transaction: String
	let token: String
}

struct KeepAliveRequest: Encodable {
	let janus = JanusMessage.keepalive.rawValue
	let session_id: Int64
	let transaction: String
	let token: String
}

struct DestroySessionRequest: Encodable {
	let janus = JanusMessage.destroy.rawValue
	let session_id: Int64
	let transaction: String
	let token: String
}

struct PublisherJoinRoomRequest: Encodable {
	
	struct Body: Encodable {
		let request = "join"
		let ptype = "publisher"
		let room: Int64
		let display: String
	}
	
	let janus = JanusMessage.message.rawValue
	let body: Body
	let transaction: String
	let session_id: Int64
	let handle_id: Int64
	let token: String
	
	init(room: Int64, sessionId: Int64, handleId: Int64, transaction: String, token: String, display: String) {
		self.session_id = sessionId
		self.handle_id = handleId
		self.transaction = transaction
		self.token = token
		self.body = Body(room: room, display: display)
	}
}

struct PublisherCreateOfferRequest: Encodable {
	struct Body: Encodable {
		let request = "configure"
		let audio = true
		let video = true
		let bitrate: Int64
	}
	
	struct Jsep: Encodable {
		let type = "offer"
		let sdp: String
	}
	
	let janus = JanusMessage.message.rawValue
	let session_id: Int64
	let handle_id: Int64
	let transaction: String
	let body: Body
	let jsep: Jsep
	let token: String
	
	init(sessionId: Int64, handleId: Int64, sdp: String, bitrate: Int64, transaction: String, token: String) {
		self.session_id = sessionId
		self.handle_id = handleId
		self.transaction = transaction
		self.token = token
		self.jsep = Jsep(sdp: sdp)
		self.body = Body(bitrate: bitrate)
	}
}

struct SubscriberCreateAnswerRequest: Encodable {
	struct Body: Encodable {
		let request = "start"
		let room: Int64
	}
	
	struct Jsep: Encodable {
		let type = "answer"
		let sdp: String
	}
	
	let janus = JanusMessage.message.rawValue
	let transaction: String
	let body: Body
	let jsep: Jsep
	let session_id: Int64
	let handle_id: Int64
	let token: String
	
	init(room: Int64, sdp: String, handleId: Int64, sessionId: Int64, transaction: String, token: String) {
		self.body = Body(room: room)
		self.jsep = Jsep(sdp: sdp)
		self.session_id = sessionId
		self.handle_id = handleId
		self.transaction = transaction
		self.token = token
	}
}

struct TrickleCandidateRequest: Encodable {
	
    struct Candidate: Encodable {
        let candidate: String
        let sdpMid: String
        let sdpMLineIndex: Int32
    }
	
	let janus = JanusMessage.trickle.rawValue
	let session_id: Int64
	let handle_id: Int64
	let transaction: String
	let token: String
	let candidate: Candidate
	
	init(sessionId: Int64, handleId: Int64, transaction: String, token: String, candidate: RTCIceCandidate) {
		self.session_id = sessionId
		self.handle_id = handleId
		self.transaction = transaction
		self.token = token
		self.candidate = Candidate(candidate: candidate.sdp,
								   sdpMid: candidate.sdpMid ?? "",
								   sdpMLineIndex: candidate.sdpMLineIndex)
        
	}
}

struct TrickleCandidateCompleteRequest: Encodable {
	struct Candidate: Encodable {
		let completed = true
	}
	
	let janus = JanusMessage.trickle.rawValue
	let session_id: Int64
	let handle_id: Int64
	let transaction: String
	let token: String
	let candidate = Candidate()
	
	init(sessionId: Int64, handleId: Int64, transaction: String, token: String) {
		self.session_id = sessionId
		self.handle_id = handleId
		self.transaction = transaction
		self.token = token
	}
}

struct SubscriberJoinRoomRequest: Encodable {
	
	struct Body: Encodable {
		let request = "join"
		let ptype = "subscriber"
		let room: Int64
		var feed: Int64?
	}
	
	let janus = JanusMessage.message.rawValue
	let body: Body
	let transaction: String
	let session_id: Int64
	let handle_id: Int64
	let token: String
	
	init(room: Int64, sessionId: Int64, handleId: Int64, transaction: String, token: String, feed: Int64?) {
		self.session_id = sessionId
		self.handle_id = handleId
		self.transaction = transaction
		self.token = token
		self.body = Body(room: room, feed: feed)
	}
}
