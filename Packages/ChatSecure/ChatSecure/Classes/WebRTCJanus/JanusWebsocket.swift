//
//  JanusWebsocket.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/18/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable weak_delegate class_delegate_protocol

import Foundation
import SocketRocket

enum WebSocketStatus {
	case connecting
	case opened
	case closing
	case closed
}

protocol WebSocketDelegate {
	func webSocket(didOpen webSocket: WebSocket)
	func webSocket(didClose webSocket: WebSocket)
	func webSocket(_ webSocket: WebSocket, didReceiveMessage msg: [String: Any])
	func webSocket(_ webSocket: WebSocket, didFailWithError error: Error)
}

class WebSocket: NSObject {
	var delegate: WebSocketDelegate?
	let serverUrl: URL
	
	init(withServer url: URL) {
		self.serverUrl = url
	}
	
	func start() -> Bool { return true }
	
	func stop() { }
	
	func send(message msg: [String: Any]?) { }
	
	func status() -> WebSocketStatus { return .closed }
}

class JanusWebSocket: WebSocket {
	let webSocket: SRWebSocket
	let webSocketQueue: DispatchQueue
	
	override init(withServer url: URL) {
		webSocket = SRWebSocket(url: url, protocols: ["janus-protocol"])
		webSocketQueue = DispatchQueue(label: "WebSocketQueue", attributes: .concurrent)
		webSocket.delegateDispatchQueue = webSocketQueue
		super.init(withServer: url)
		webSocket.delegate = self
	}
	
	override func start() -> Bool {
		webSocket.open()
		return true
	}
	
	override func stop() {
		webSocket.close()
	}
	
	override func status() -> WebSocketStatus {
		switch webSocket.readyState {
		case .CONNECTING:
			return .connecting
		case .OPEN:
			return .opened
		case .CLOSING:
			return .closing
		case .CLOSED:
			return .closed
		default:
			return .closed
		}
	}
	
	override func send(message msg: [String: Any]?) {
		guard var msgDict = msg else { return }
		//        msgDict["token"] = "a1b2c3d4"
		print(String(format: "Message send: %@", msgDict))
		do {
			let json = try JSONSerialization.data(withJSONObject: msgDict, options: .prettyPrinted)
			webSocket.send(json)
		} catch {
			debugPrint("error: \(error.localizedDescription)")
		}
	}
}

// MARK: - SRWebSocketDelegate
extension JanusWebSocket: SRWebSocketDelegate {
	func webSocketDidOpen(_ webSocket: SRWebSocket!) {
		debugPrint("webSocketDidOpen")
		self.delegate?.webSocket(didOpen: self)
	}
	
	func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
		debugPrint("webSocket: SRWebSocket!, didReceiveMessage message: ", message ?? "")
		guard let message = message as? String else { return }
		let data = Data(message.utf8)
		do {
			// make sure this JSON is in the format we expect
			if let msgJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				self.delegate?.webSocket(self, didReceiveMessage: msgJson)
			}
		} catch let error as NSError {
			print("Failed to load: \(error.localizedDescription)")
		}
	}
	
	func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
		debugPrint("webSocket: SRWebSocket!, didReceivePong")
	}
	
	func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
		debugPrint("webSocket: SRWebSocket!, didFailWithError")
		self.delegate?.webSocket(self, didFailWithError: error)
	}
	
	func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
		debugPrint("webSocket: SRWebSocket!, didCloseWithCode code: \(code)")
		self.delegate?.webSocket(didClose: self)
	}
}
