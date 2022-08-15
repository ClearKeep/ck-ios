//
//  Janus+WebSocketDelegate.swift
//  JanusWebRTC
//
//  Created by Nguyen Luan on 12/19/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity function_body_length

import Foundation

extension Janus: WebSocketDelegate {
	func webSocket(didOpen webSocket: WebSocket) {
		createSession()
		connectCallback?(nil)
	}
	
	func webSocket(_ webSocket: WebSocket, didReceiveMessage msg: [String: Any]) {
		guard let janus = msg["janus"] as? String else {
			return
		}
		
		if janus == "ack" {
			debugPrint("Got an ack on session: \(sessionId)")
			return
		}
		
		self.mainque.async {
			if let transaction = msg["transaction"] as? String,
			   let callback = self.janusTransactions[transaction] {
				self.janusTransactions = self.janusTransactions.filter({ $0.key != transaction })
				callback(msg)
				return
			}
			
			repeat {
				if janus == JanusMessage.keepalive.rawValue {
					debugPrint("JanusMessage.keepalive on session: \(self.sessionId)")
					break
				} else if janus == JanusMessage.success.rawValue {
					debugPrint("JanusMessage.success not handle")
					break
				} else if janus == JanusMessage.event.rawValue {
					debugPrint("JanusMessage.event")
					guard let handleId = msg["sender"] as? NSNumber else {
						debugPrint("Missing handle...")
						break
					}
					guard let plugindata = msg["plugindata"] as? [String: Any] else {
						debugPrint("Missing plugindata...")
						break
					}
					if let data = plugindata["data"] as? [String: Any],
					   let pluginHandle = self.pluginHandlers[handleId] {
						let jsep = msg["jsep"] as? [String: Any]
						let transaction = msg["transaction"] as? String
						pluginHandle.pluginHandle(message: data, jsep: jsep, transaction: transaction)
					}
				} else if janus == JanusMessage.webrtcup.rawValue {
					debugPrint("JanusMessage.webrtcup")
					guard let handleId = msg["sender"] as? NSNumber else {
						debugPrint("Missing handle")
						break
					}
					guard let pluginHandle = self.pluginHandlers[handleId] else {
						debugPrint("This handle is not attached to this session")
						break
					}
					pluginHandle.pluginWebrtc(state: true)
				} else if janus == JanusMessage.media.rawValue {
					debugPrint("")
					guard let handleId = msg["sender"] as? NSNumber else {
						debugPrint("Missing handle")
						break
					}
					guard let pluginHandle = self.pluginHandlers[handleId] else {
						debugPrint("This handle is not attached to this session")
						break
					}
					var mediaType: RTCMediaType = .audio
					if let type = msg["type"] as? String, let state = msg["receiving"] as? Bool {
						if type == "video" {
							mediaType = .video
						} else if type == "audio" {
							mediaType = .audio
						}
						pluginHandle.pluginUpdateMedia(state: state, type: mediaType)
					}
				} else if janus == JanusMessage.error.rawValue {
					debugPrint("JanusMessage.error")
					break
				} else if janus == JanusMessage.slowlink.rawValue {
					debugPrint("JanusMessage.slowlink")
				} else if janus == JanusMessage.hangup.rawValue {
					debugPrint("JanusMessage.hangup")
					guard let handleId = msg["sender"] as? NSNumber else {
						debugPrint("Missing handle")
						break
					}
					guard let pluginHandle = self.pluginHandlers[handleId] else {
						debugPrint("This handle is not attached to this session")
						break
					}
					if let reason = msg["reason"] as? String {
						pluginHandle.pluginDTLSHangup(withReason: reason)
					}
				} else if janus == JanusMessage.deteched.rawValue {
					debugPrint("JanusMessage.deteched")
					guard let handleId = msg["sender"] as? NSNumber else {
						debugPrint("Missing handle")
						break
					}
					guard let pluginHandle = self.pluginHandlers[handleId] else {
						debugPrint("This handle is not attached to this session")
						break
					}
					self.pluginHandlers.removeValue(forKey: handleId)
					pluginHandle.pluginDetected()
				} else if janus == JanusMessage.timeout.rawValue {
					debugPrint("JanusMessage.timeout")
				} else {
					debugPrint("Not handle")
				}
			} while(false)
		}
	}
	
	func webSocket(_ webSocket: WebSocket, didFailWithError error: Error) {
		self.mainque.async {
			if let keepAliveTimer = self.keepAliveTimer {
				keepAliveTimer.invalidate()
				self.keepAliveTimer = nil
			}
			self.janusWebSocket = nil
			self.sessionId = 0
			
			let errDict = ["code": NSNumber(value: -1),
						   "reason": error.localizedDescription] as [String: Any]
			let errMsg = ["janus": "error", "error": errDict] as [String: Any]
			for callback in self.janusTransactions.values {
				callback(errMsg)
			}
			self.janusTransactions.removeAll()
			self.delayReq.removeAll()
			self.delegate?.janus(self, netBrokenWithId: .websocketFail)
		}
	}
	
	func webSocket(didClose webSocket: WebSocket) {
		mainque.sync(flags: .barrier) {
			if let keepAliveTimer = keepAliveTimer {
				keepAliveTimer.invalidate()
				self.keepAliveTimer = nil
			}
			
			janusWebSocket = nil
			sessionId = 0
			
			let errMsg = ["janus": "error"] as [String: Any]
			for callback in janusTransactions.values {
				callback(errMsg)
			}
			janusTransactions.removeAll()
			delayReq.removeAll()
			self.delegate?.janus(self, netBrokenWithId: .websocketClose)
		}
	}
}
