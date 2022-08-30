//
//  Janus.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/18/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable weak_delegate

import UIKit

class Janus: NSObject {
	var delegate: JanusDelegate?
	let server: URL
	var sessionId: Int = 0
	var janusWebSocket: JanusWebSocket?
	var pluginHandlers = [NSNumber: JanusPluginHandleProtocol]()
	var delayReq = [[String: Any]]()
	var janusTransactions = [String: JanusRequestCallback]()
	var token: String?
	let apiSecret: String?
	var keepAliveTimer: Timer?
	let keepAliveInterval: Int
	var connectCallback: ((Error?) -> Void)?
	let mainque = DispatchQueue.main
	
	init(withServer server: URL, delegate: JanusDelegate? = nil, token: String?, apiSecret: String? = nil) {
		self.server = server
		self.delegate = delegate
		self.token = token
		self.janusWebSocket = JanusWebSocket(withServer: server)
		self.apiSecret = apiSecret
		self.keepAliveInterval = 30000
		super.init()
		self.janusWebSocket?.delegate = self
	}
	
	deinit {
		janusWebSocket?.stop()
	}
	
	func connect(completion: ((Error?) -> Void)?) {
		connectCallback = completion
		janusWebSocket?.start()
	}
	
	func stop() {
		janusWebSocket?.stop()
	}
	
	func createSession() {
		let transaction = randomString(withLength: 12)
		var params = [String: Any]()
		params["janus"] = JanusMessage.create.rawValue
		params["transaction"] = transaction
		let callback: JanusRequestCallback = { [weak self] msg in
			guard let self = self else { return }
			self.handleCreateSessionCallback(msg: msg)
		}
		if let token = self.token {
			params["token"] = token
		}
		mainque.sync(flags: .barrier) {
			janusTransactions.updateValue(callback, forKey: transaction)
			janusWebSocket?.send(message: params)
		}
	}
	
	// MARK: - Attach WebSocket
	func attachPlugin(plugin: JanusPluginHandleProtocol,
					  callback: @escaping AttachCallback) {
		mainque.async {
			var transaction = randomString(withLength: 12)
			while self.janusTransactions.keys.contains(transaction) {
				transaction = randomString(withLength: 12)
			}
			
			var params = ["janus": JanusMessage.attach.rawValue,
						  "plugin": plugin.pluginName,
						  "opaque_id": plugin.opaqueId,
						  "transaction": transaction,
						  "session_id": NSNumber(value: self.sessionId)] as [String: Any]
			if let token = self.token {
				params["token"] = token
			}
			if let secret = self.apiSecret {
				params["apisecret"] = secret
			}
			let reqCallback: JanusRequestCallback = { [weak self] msg in
				guard let self = self else { return }
				self.handleAttachPluginCallback(plugin: plugin,
												pluginCallback: callback,
												msg: msg)
			}
			self.janusTransactions.updateValue(reqCallback, forKey: transaction)
			if self.sessionId == 0 {
				self.delayReq.append(params)
				if self.janusWebSocket == nil {
					self.janusWebSocket = JanusWebSocket(withServer: self.server)
					self.janusWebSocket?.delegate = self
					self.janusWebSocket?.start()
				}
			} else {
				self.janusWebSocket?.send(message: params)
			}
		}
	}
	
	// MARK: - Detach WebSocket
	func detachPlugin(plugin: JanusPluginHandleProtocol, callback: DetachCallback?) {
		mainque.async {
			self.pluginHandlers.removeValue(forKey: plugin.handleId)
			
			if self.sessionId == 0 || !plugin.attached || self.janusWebSocket != nil {
				if let reqCallback = callback {
					reqCallback(nil)
				}
				return
			}
			
			var transaction = randomString(withLength: 12)
			while self.janusTransactions.keys.contains(transaction) {
				transaction = randomString(withLength: 12)
			}
			
			var params = ["janus": JanusMessage.detach,
						  "handle_id": plugin.handleId,
						  "transaction": transaction,
						  "session_id": NSNumber(value: self.sessionId)] as [String: Any]
			if let token = self.token {
				params["token"] = token
			}
			if let secret = self.apiSecret {
				params["apisecret"] = secret
			}
			let callbackJanus: JanusRequestCallback = {[weak self] msg in
				if let reqCallback = callback {
					if let janus = msg["janus"] as? String, janus == "success" {
						reqCallback(nil)
					} else if let janus = msg["janus"] as? String, janus == "error" {
						reqCallback(JanusResultError.funcErr(msg: "Detach error"))
					}
				}
			}
			
			self.janusTransactions.updateValue(callbackJanus, forKey: transaction)
			self.janusWebSocket?.send(message: params)
		}
	}
	
	// MARK: - Destroy Session
	func destroySession() {
		if let keepAliveTimer = keepAliveTimer {
			keepAliveTimer.invalidate()
			self.keepAliveTimer = nil
		}
		
		let transaction = randomString(withLength: 12)
		var params = ["janus": JanusMessage.destroy.rawValue,
					  "transaction": transaction,
					  "session_id": NSNumber(value: sessionId)] as [String: Any]
		if let token = token {
			params["token"] = token
		}
		if let secret = apiSecret {
			params["apisecret"] = secret
		}
		let callback: JanusRequestCallback = { [weak self] _ in
			guard let self = self else { return }
			self.sessionId = 0
			self.delegate?.janusDestroy(self)
		}
		mainque.async {
			self.janusTransactions.updateValue(callback, forKey: transaction)
			self.janusWebSocket?.send(message: params)
		}
	}
	
	// MARK: - Send Message WebSocket
	func send(message msg: [String: Any], handleId: NSNumber, callback: @escaping PluginRequestCallback) {
		self.send(message: msg, jsep: nil, handleId: handleId, callback: callback)
	}
	
	func send(message msg: [String: Any], jsep: [String: Any]?, handleId: NSNumber, callback: @escaping PluginRequestCallback) {
		mainque.async {
			if self.sessionId == 0 || self.janusWebSocket == nil {
				let data = ["error_code": NSNumber(value: -1), "error": "sessionID januswebsocket = 0"] as [String: Any]
				callback(data, nil)
				return
			}
			
			var transaction = randomString(withLength: 12)
			while self.janusTransactions.keys.contains(transaction) {
				transaction = randomString(withLength: 12)
			}
			var params: [String: Any]
			if let jsep = jsep {
				params = ["janus": JanusMessage.message.rawValue,
						  "body": msg,
						  "jsep": jsep,
						  "transaction": transaction,
						  "session_id": NSNumber(value: self.sessionId),
						  "handle_id": handleId]
			} else {
				params = ["janus": JanusMessage.message.rawValue,
						  "body": msg,
						  "transaction": transaction,
						  "session_id": NSNumber(value: self.sessionId),
						  "handle_id": handleId]
			}
			
			if let token = self.token {
				params["token"] = token
			}
			if let secret = self.apiSecret {
				params["apisecret"] = secret
			}
			let callbackJanus: JanusRequestCallback = {[weak self] msg in
				if let janus = msg["janus"] as? String, janus == "error",
				   let error = msg["error"] as? [String: Any] {
					let data: [String: Any] = ["error_code": error["code"] ?? "", "error_reason": error["reason"] ?? ""]
					callback(data, nil)
				} else if let pluginData = msg["plugindata"] as? [String: Any],
						  let data = pluginData["data"] as? [String: Any] {
					let jsep = msg["jsep"] as? [String: Any]
					callback(data, jsep)
				} else {
					debugPrint("send no handle callback")
				}
			}
			
			self.janusTransactions.updateValue(callbackJanus, forKey: transaction)
			self.janusWebSocket?.send(message: params)
		}
	}
	
	func send(trickleCandidate candidate: [String: Any], handleId: NSNumber) {
		self.mainque.async {
			if self.sessionId == 0 || self.janusWebSocket == nil {
				return
			}
			
			var transaction = randomString(withLength: 12)
			while self.janusTransactions.keys.contains(transaction) {
				transaction = randomString(withLength: 12)
			}
			
			var params = ["janus": JanusMessage.trickle.rawValue,
						  "candidate": candidate,
						  "transaction": transaction,
						  "handle_id": handleId,
						  "session_id": NSNumber(value: self.sessionId)] as [String: Any]
			if let token = self.token {
				params["token"] = token
			}
			self.janusWebSocket?.send(message: params)
		}
	}
	
	// MARK: - Private function
	private func handleCreateSessionCallback(msg: [String: Any]) {
		if let janus = msg["janus"] as? String,
		   janus == "success" {
			if let sessionData = msg["data"] as? [String: Any] {
				self.sessionId = sessionData["id"] as! Int
				if self.keepAliveInterval > 0 {
					asyncInMainThread {
						self.keepAliveTimer = Timer.scheduledTimer(timeInterval: 30.0,
																   target: self,
																   selector: #selector(self.sessionKeepAlive(timer:)),
																   userInfo: nil,
																   repeats: true)
					}
				}
				for request in self.delayReq {
					self.sendDelayReq(request: request)
				}
				self.delegate?.janus(self, createComplete: nil)
			} else {
				self.delegate?.janus(self, createComplete: JanusResultError.jsonErr(msg: "json error"))
			}
		} else {
			self.delegate?.janus(self, createComplete: JanusResultError.funcErr(msg: "janus create session"))
		}
	}
	
	private func handleAttachPluginCallback(plugin: JanusPluginHandleProtocol, pluginCallback: AttachCallback, msg: [String: Any]) {
		if let janus = msg["janus"] as? String,
		   janus == "success" {
			if let sessionData = msg["data"] as? [String: Any],
			   let id = sessionData["id"] as? Int {
				let handleId = NSNumber(value: id)
				self.pluginHandlers[handleId] = plugin
				plugin.handleId = handleId
				pluginCallback(handleId, nil)
			} else {
				self.delegate?.janus(self, createComplete: JanusResultError.jsonErr(msg: "json error"))
			}
		} else if let janus = msg["janus"] as? String,
				  janus == "error",
				  let error = msg["error"] as? [String: Any] {
			pluginCallback(0, JanusResultError.codeErr(code: error["code"] as! Int, desc: error["reason"] as? String))
		} else {
			debugPrint("no handle")
		}
	}
	
	@objc private func sessionKeepAlive(timer: Timer) {
		if sessionId != 0, let websocket = janusWebSocket {
			let transaction = randomString(withLength: 12)
			var params = ["janus": JanusMessage.keepalive.rawValue,
						  "session_id": NSNumber(value: sessionId),
						  "transaction": transaction] as [String: Any]
			if let token = self.token {
				params["token"] = token
			}
			websocket.send(message: params)
		}
	}
	
	private func sendDelayReq(request: [String: Any]) {
		if sessionId != 0 {
			var newRequestDict = request
			newRequestDict["session_id"] = NSNumber(value: sessionId)
			janusWebSocket?.send(message: newRequestDict)
		}
	}
}
