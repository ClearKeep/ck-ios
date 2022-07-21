//
//  JanusRole.swift
//  JanusWebRTC
//
//  Created by Nguyen Luan on 12/19/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import UIKit
import WebRTC

typealias RoleJoinRoomCallback = (Error?) -> Void
typealias RoleLeaveRoomCallback = () -> Void

enum PublishType {
	case lister
	case publish
}

enum JanusRoleStatus: Int {
	case detached
	case detaching
	case attaching
	case attached
	case joining
	case joined
	case leaveing
	case leaved
}

protocol JanusRoleDelegate: JanusPluginDelegate {
	func janusRole(role: JanusRole, joinRoomWithResult error: Error?)
	func janusRole(role: JanusRole, leaveRoomWithResult error: Error?)
	
	func janusRole(role: JanusRole?, didJoinRemoteRole remoteRole: JanusRoleListen)
	func janusRole(role: JanusRole, didLeaveRemoteRoleWithUid uid: Int)
	func janusRole(role: JanusRole, remoteUnPublishedWithUid uid: Int)
	func janusRole(role: JanusRole, remoteDetachWithUid uid: Int)
	func janusRole(role: JanusRole, fatalErrorWithID code: RTCErrorCode)
	func janusRole(role: JanusRole, netBrokenWithID reason: RTCNetBrokenReason)
}

extension JanusRoleDelegate {
	func janusRole(role: JanusRole, didReceiveData data: Data) { }
}

class JanusRole: JanusPlugin {
	var id: Int?
	var roomId: Int64?
	var privateId: NSNumber?
	var pType: PublishType = .publish
	var display: String?
	var mediaConstraints: JanusMediaConstraints?
	var status: JanusRoleStatus = .detached
	var turnServer: TurnServer
	var stunServer: StunServer
	
	var audioCode: String?
	var videoCode: String?
	var localDataChannel: RTCDataChannel?
	var remoteDataChannel: RTCDataChannel?
	
	private var _peerConnection: RTCPeerConnection?
	
	init(withJanus janus: Janus, delegate: JanusRoleDelegate? = nil, turnServer: TurnServer, stunServer: StunServer) {
		self.turnServer = turnServer
		self.stunServer = stunServer
		super.init(withJanus: janus, delegate: delegate)
		janus.delegate = self
		self.opaqueId = "videoroomtest-\(randomString(withLength: 12))"
		self.pluginName = "janus.plugin.videoroom"
		
	}
	
	class func role(withDict dict: [String: Any], janus: Janus, delegate: JanusRoleDelegate?, turnServer: TurnServer, stunServer: StunServer) -> JanusRole {
		let publish = JanusRole(withJanus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
		return publish
	}
	
	override func attach(withCallback callback: AttachResult?) {
		status = .attaching
		super.attach { [weak self](error) in
			if error == nil {
				self?.status = .attached
			} else {
				self?.status = .detached
			}
			if let callback = callback {
				callback(error)
			}
		}
	}
	
	override func detach(withCallback callback: DetachedResult?) {
		if status.rawValue <= JanusRoleStatus.detaching.rawValue {
			return
		}
		status = .detaching
		super.detach { [weak self] in
			self?.status = .detached
			if let callback = callback {
				callback()
			}
		}
	}
	
	var peerConnection: RTCPeerConnection? {
		RTCInitializeSSL()
		if let peerConnection = _peerConnection {
			return peerConnection
		}
		let configuration = RTCConfiguration()
		let stun = RTCIceServer(urlStrings: [stunServer.server])
		let turn = RTCIceServer(urlStrings: [turnServer.server],
								username: turnServer.user,
								credential: turnServer.pwd)
		configuration.iceServers = [stun, turn]
		configuration.iceTransportPolicy = .all
		let constraints = JanusMediaConstraints().getPeerConnectionConstraints()
		_peerConnection = RTCFactory.shared.peerConnectionFactory().peerConnection(with: configuration,
																				   constraints: constraints,
																				   delegate: self)
		return _peerConnection
	}
	
	func joinRoom(withRoomId roomId: Int64, username: String?, callback: @escaping RoleJoinRoomCallback) {
		self.roomId = roomId
		var msg: [String: Any]
		if pType == .publish {
			msg = ["request": "join", "room": NSNumber(value: roomId), "ptype": "publisher"]
			//            msg["display"] = Multiserver.instance.currentServer.getUserLogin()?.id
			//            if let username = username {
			//                msg["display"] = Multiserver.instance.currentServer.getUserLogin()?.id ?? username
			//            }
		} else {
			msg = ["request": "join", "room": NSNumber(value: roomId), "ptype": "subscriber"]
			if let id = self.id, let privateId = self.privateId {
				msg["feed"] = NSNumber(value: id)
				msg["private_id"] = privateId
			}
		}
		
		status = .joining
		self.janus?.send(message: msg, handleId: handleId) { [weak self](msg, jsep) in
			if let error = msg["error"] as? [String: Any],
			   let code = error["error_code"] as? Int,
			   let errMsg = msg["error"] as? String {
				callback(JanusResultError.codeErr(code: code, desc: errMsg))
			} else {
				self?.status = .joined
				self?.id = msg["id"] as? Int
				self?.privateId = msg["private_id"] as? NSNumber
				callback(nil)
				if let publishers = msg["publishers"] as? [[String: Any]],
				   let janus = self?.janus,
				   let turnServer = self?.turnServer,
				   let stunServer = self?.stunServer,
				   let delegate = self?.delegate as? JanusRoleDelegate {
					for item in publishers {
						let listenter = JanusRoleListen.role(withDict: item, janus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
						listenter.privateId = self?.privateId
						listenter.opaqueId = self?.opaqueId
						delegate.janusRole(role: self, didJoinRemoteRole: listenter)
					}
				}
				if let jsep = jsep {
					self?.handleRemote(jsep: jsep)
				}
			}
		}
	}
	
	func leaveRoom(callback: @escaping RoleLeaveRoomCallback) {
		let msg = ["request": "leave"]
		if status.rawValue > JanusRoleStatus.joining.rawValue {
			status = .leaveing
			self.janus?.send(message: msg, handleId: handleId) { [weak self] _, _ in
				guard let self = self else { return }
				self.status = .leaved
				if let delegate = self.delegate as? JanusRoleDelegate {
					delegate.janusRole(role: self, leaveRoomWithResult: nil)
				}
				callback()
			}
		}
	}
	
	func destroyRTCPeer() {
		_peerConnection?.close()
		_peerConnection = nil
	}
	
	deinit {
		self.destroyRTCPeer()
	}
	
	func newRemoteFeed(listener: JanusRoleListen) {
		if let delegate = self.delegate as? JanusRoleDelegate {
			delegate.janusRole(role: self, didJoinRemoteRole: listener)
		}
	}
	
	func handleRemote(jsep: [String: Any]) { }
	
	// MARK: - Janus Delegate
	override func pluginWebrtc(state on: Bool) { }
	
	override func pluginDTLSHangup(withReason reason: String) {
		if self.status == .joined, let roomId = self.roomId {
			self.leaveRoom { [weak self] in
				self?.joinRoom(withRoomId: roomId, username: self?.display, callback: { (error) in
					if error != nil {
						debugPrint("joinRoom error: \(error?.localizedDescription ?? "")")
					}
				})
			}
		}
	}
	
	override func pluginDetected() {
		super.pluginDetected()
		self.status = .detached
	}
}

// MARK: - Controlling the bandwidth video
extension JanusRole {
	func setMediaBitrates(sdp: String, videoBitrate: Int, audioBitrate: Int) -> String {
		return setMediaBitrate(sdp: setMediaBitrate(sdp: sdp, mediaType: "video", bitrate: videoBitrate),
							   mediaType: "audio",
							   bitrate: audioBitrate)
	}
	
	private func setMediaBitrate(sdp: String, mediaType: String, bitrate: Int) -> String {
		var lines = sdp.components(separatedBy: "\n")
		var line = -1
		
		for (index, lineString) in lines.enumerated() {
			if lineString.hasPrefix("m=\(mediaType)") {
				line = index
				break
			}
		}
		
		guard line != -1 else {
			// Couldn't find the m (media) line return the original sdp
			print("Couldn't find the m line in SDP so returning the original sdp")
			return sdp
		}
		
		// Go to next line i.e. line after m
		line += 1
		
		// Now skip i and c lines
		while lines[line].hasPrefix("i=") || lines[line].hasPrefix("c=") {
			line += 1
		}
		
		let newLine = "b=AS:\(bitrate)"
		// Check if we're on b (bitrate) line, if so replace it
		if lines[line].hasPrefix("b") {
			print("Replacing the b line of the SDP")
			lines[line] = newLine
		} else {
			// If there's no b line, add a new b line
			lines.insert(newLine, at: line)
		}
		
		let modifiedSDP = lines.joined(separator: "\n")
		return modifiedSDP
	}
}

extension JanusRole: RTCPeerConnectionDelegate {
	func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
		
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
		
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
		
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
		
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
		
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
		if newState == .complete {
			let publish = ["completed": NSNumber(value: true)]
			send(trickleCandidate: publish)
		}
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
		var publish: [String: Any]
		if let mid = candidate.sdpMid {
			publish = ["candidate": candidate.sdp,
					   "sdpMid": mid,
					   "sdpMLineIndex": NSNumber(value: candidate.sdpMLineIndex)]
		} else {
			publish = ["completed": NSNumber(value: true)]
		}
		self.send(trickleCandidate: publish)
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
		
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
		self.remoteDataChannel = dataChannel
	}
}

extension JanusRole: JanusDelegate {
	func janus(_ janus: Janus, createComplete error: Error?) {
		if error != nil {
			if let delegateRole = self.delegate as? JanusRoleDelegate {
				delegateRole.janusRole(role: self, fatalErrorWithID: .serverErr)
			}
		}
	}
	
	func janus(_ janus: Janus, netBrokenWithId reason: RTCNetBrokenReason) {
		if let delegateRole = self.delegate as? JanusRoleDelegate {
			delegateRole.janusRole(role: self, netBrokenWithID: reason)
		}
	}
	
	func janus(_ janus: Janus, attachPlugin handleId: NSNumber, result error: Error?) { }
	
	func janusDestroy(_ janus: Janus?) { }
}
