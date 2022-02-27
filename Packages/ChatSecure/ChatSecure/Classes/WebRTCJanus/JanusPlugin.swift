//
//  JanusPlugin.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/18/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable weak_delegate class_delegate_protocol

import UIKit

typealias AttachResult = (Error?) -> Void
typealias DetachedResult = () -> Void

protocol JanusPluginDelegate { }

protocol JanusPluginHandleProtocol: NSObject {
	var handleId: NSNumber { get set }
	var pluginName: String? { get set }
	var opaqueId: String? { get set }
	var attached: Bool { get set }
	
	func pluginHandle(message msg: [String: Any], jsep: [String: Any]?, transaction: String?)
	func pluginWebrtc(state on: Bool)
	func pluginDetected()
	func pluginUpdateMedia(state on: Bool, type: RTCMediaType)
	func pluginDTLSHangup(withReason reason: String)
}

class JanusPlugin: NSObject, JanusPluginHandleProtocol {
	var opaqueId: String?
	var pluginName: String?
	var handleId = NSNumber(value: 0)
	var attached: Bool = false
	weak var janus: Janus?
	var delegate: JanusPluginDelegate?
	var transactions = [String: Any]()
	
	init(withJanus janus: Janus, delegate: JanusPluginDelegate?) {
		self.janus = janus
		self.delegate = delegate
		super.init()
	}
	
	func send(message msg: [String: Any], callback: @escaping PluginRequestCallback) {
		janus?.send(message: msg, jsep: nil, handleId: handleId, callback: callback)
	}
	
	func send(message msg: [String: Any], jsep: [String: Any], callback: @escaping PluginRequestCallback) {
		janus?.send(message: msg, jsep: jsep, handleId: handleId, callback: callback)
	}
	
	func send(trickleCandidate candidate: [String: Any]) {
		janus?.send(trickleCandidate: candidate, handleId: handleId)
	}
	
	func attach(withCallback callback: @escaping AttachResult) {
		janus?.attachPlugin(plugin: self) { [weak self](handleId, error) in
			self?.handleId = handleId
			self?.attached = error == nil
			callback(error)
		}
	}
	
	func detach(withCallback callback: DetachedResult?) {
		janus?.detachPlugin(plugin: self) { [weak self] _ in
			guard let self = self else { return }
			self.attached = false
			if let callback = callback {
				callback()
			}
		}
	}
	
	func pluginHandle(message msg: [String: Any], jsep: [String: Any]?, transaction: String?) { }
	
	func pluginWebrtc(state on: Bool) { }
	
	func pluginDetected() {
		attached = false
	}
	
	func pluginUpdateMedia(state on: Bool, type: RTCMediaType) { }
	
	func pluginDTLSHangup(withReason reason: String) { }
}
