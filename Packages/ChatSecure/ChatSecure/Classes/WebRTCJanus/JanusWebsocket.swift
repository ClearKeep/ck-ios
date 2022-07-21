//
//  JanusWebsocket.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/18/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import Common
// swiftlint:disable weak_delegate class_delegate_protocol

protocol WebSocketDelegate {
	func webSocket(didOpen webSocket: WebSocketProvider)
	func webSocket(didClose webSocket: WebSocketProvider)
	func webSocket(_ webSocket: WebSocketProvider, didReceiveMessage msg: [String: Any])
	func webSocket(_ webSocket: WebSocketProvider, didReceiveMessage msg: String)
	func webSocket(_ webSocket: WebSocketProvider, didFailWithError error: Error)
}

protocol WebSocketProvider {
	var delegate: WebSocketDelegate? { get set }
	func start()
	func stop()
	func send(message msg: [String: Any]?)
	func send<T: Encodable>(message: T)
}

final class JanusWebSocket: NSObject, WebSocketProvider {
	var delegate: WebSocketDelegate?

	private var webSocket: URLSessionWebSocketTask?
	private var urlSession: URLSession?
	private let delegateQueue = OperationQueue()
	
	private lazy var encoder: JSONEncoder = {
		let jsonEncoder = JSONEncoder()
		jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
		return jsonEncoder
	}()

	init(withServer url: URL) {
		super.init()
		self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
		var request = URLRequest(url: url)
		let protocols = ["janus-protocol"]
		request.setValue(protocols.joined(separator: ","), forHTTPHeaderField: "Sec-WebSocket-Protocol")
		request.timeoutInterval = 10
		webSocket = urlSession?.webSocketTask(with: request)
	}
	
	func start() {
		webSocket?.resume()
		listen()
	}
	
	func stop() {
		webSocket?.cancel(with: .goingAway, reason: nil)
//		webSocket = nil
//		delegate?.webSocket(didClose: self)
	}

	func send(message msg: [String: Any]?) {
		guard var msgDict = msg else { return }
		Debug.DLog("webSocket send message: \(msgDict)")
		do {
			let json = try JSONSerialization.data(withJSONObject: msgDict, options: .prettyPrinted)
			webSocket?.send(URLSessionWebSocketTask.Message.data(json), completionHandler: { error in
				Debug.DLog("webSocket send data fail with error: \(error)")
				if let error = error {
					self.delegate?.webSocket(self, didFailWithError: error)
				}
			})
		} catch {
			Debug.DLog("webSocket send message fail with error: \(error)")
		}
	}
	
	func send<T: Encodable>(message: T) {
		do {
			Debug.DLog("webSocket send message: \(message)")
			let msg = try encoder.encode(message)
			webSocket?.send(URLSessionWebSocketTask.Message.data(msg), completionHandler: { error in
				if let error = error {
					Debug.DLog("webSocket send data fail with error: \(error)")
					self.delegate?.webSocket(self, didFailWithError: error)
				}
			})
		} catch {
			Debug.DLog("webSocket send message fail with error: \(error)")
		}
	}
	
	private func listen() {
		webSocket?.receive { [weak self] message in
			guard let weakSelf = self else { return }
			switch message {
			case .failure(let error):
				Debug.DLog("webSocket did fail with error: \(error)")
				weakSelf.delegate?.webSocket(weakSelf, didFailWithError: error)
				return
			case .success(let message):
				switch message {
				case .string(let text):
					Debug.DLog("webSocket did receive text message: \(text)")
					guard let source = text.data(using: .utf8) else {
						Debug.DLog("!Process Data -> String Error!")
						return
					}
					do {
						let obj = try JSONSerialization.jsonObject(with: source, options: [])
						guard let data = obj as? [String: Any] else { return }
						weakSelf.delegate?.webSocket(weakSelf, didReceiveMessage: data)
					} catch {
						Debug.DLog("Failed to load: \(error.localizedDescription)")
					}
				case .data(let data):
					Debug.DLog("webSocket did receive data message: \(data)")
					// weakSelf.delegate?.webSocket(weakSelf, didReceiveMessage: data)
					do {
						// make sure this JSON is in the format we expect
						if let msgJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
							weakSelf.delegate?.webSocket(weakSelf, didReceiveMessage: msgJson)
						}
					} catch let error as NSError {
						Debug.DLog("Failed to load: \(error.localizedDescription)")
					}
				@unknown default:
					fatalError()
				}
				
				weakSelf.listen()
			}
			
		}
	}
}
// MARK: - WebSocketDelegate
extension JanusWebSocket: URLSessionWebSocketDelegate {
	
	func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
		Debug.DLog("webSocketDidOpen")
		delegate?.webSocket(didOpen: self)
	}
	
	func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
		Debug.DLog("webSocketDidClose with code \(closeCode)")
		delegate?.webSocket(didClose: self)
	}
}
