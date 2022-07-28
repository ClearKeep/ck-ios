//
//  JanusRoleListen.swift
//  JanusWebRTC
//
//  Created by Nguyen Luan on 12/19/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import UIKit
import WebRTC

protocol JanusRoleListenDelegate: JanusRoleDelegate {
	func janusRoleListen(role: JanusRoleListen, firstRenderWithSize size: CGSize)
	func janusRoleListen(role: JanusRoleListen, renderSizeChangeWithSize size: CGSize)
}

public class JanusRoleListen: JanusRole {
	var renderView: RTCMTLEAGLVideoView?
	var videoTrack: RTCVideoTrack?
	public var renderSize: CGSize = .zero
	
	override init(withJanus janus: Janus, delegate: JanusRoleDelegate? = nil, turnServer: TurnServer, stunServer: StunServer) {
		super.init(withJanus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
		self.pType = .lister
		self.mediaConstraints = JanusMediaConstraints()
		self.mediaConstraints?.audioEnable = true
		self.mediaConstraints?.videoEnable = true
	}
	
	override class func role(withDict dict: [String: Any],
							 janus: Janus,
							 delegate: JanusRoleDelegate?,
							 turnServer: TurnServer,
							 stunServer: StunServer) -> JanusRoleListen {
		let publish = JanusRoleListen(withJanus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
		publish.pType = .lister
		if let videoCode = dict["video_codec"] as? String,
		   let id = dict["id"] as? Int {
			publish.id = id
			// TODO: send client ID here, then use it to fetch username from group info.
			publish.display = dict["display"] as? String
			publish.audioCode = dict["audio_codec"] as? String
			publish.videoCode = videoCode
		}
		return publish
	}
	
	override func joinRoom(withRoomId roomId: Int64, username: String?, callback: @escaping RoleJoinRoomCallback) {
		if !self.attached, self.status == .detached, roomId > 0 {
			self.attach { [weak self] (error) in
				guard let self = self else {
					callback(JanusResultError.codeErr(code: -1, desc: "Listener attach error"))
					return
				}
				if let error = error {
					callback(error)
				} else {
					self.joinRoom(withRoomId: roomId, username: username) { (error) in
						callback(error)
					}
				}
			}
			return
		}
		super.joinRoom(withRoomId: roomId, username: username, callback: callback)
	}
	
	override func leaveRoom(callback: @escaping RoleLeaveRoomCallback) {
		super.leaveRoom {
			callback()
		}
	}
	
	override func handleRemote(jsep: [String: Any]) {
		if let sdp = jsep["sdp"] as? String {
			var sdpType = RTCSdpType.answer
			if let type = jsep["type"] as? String, type == "answer" {
				sdpType = .answer
			} else if let type = jsep["type"] as? String, type == "offer" {
				sdpType = .offer
			} else {
				debugPrint("No handle remote jsep")
			}
			
			let sessionDest = RTCSessionDescription(type: sdpType, sdp: sdp)
			self.peerConnection?.setRemoteDescription(sessionDest, completionHandler: { [weak self] error in
				guard let self = self else { return }
				if let error = error {
					debugPrint("Listen Role setRemoteDescription error: \(error.localizedDescription)")
				} else {
					guard let constraints = self.mediaConstraints?.getAnswerConstraints() else { return }
					self.peerConnection?.answer(for: constraints) { (sdp, error) in
						if let error = error {
							debugPrint("peerConnection answerForConstraints error: \(error.localizedDescription)")
						} else if let sdpDict = sdp {
							var modifiedSDP = sdpDict
							// test lowData mode enable
							let lowDataModeEnabled = false
							if lowDataModeEnabled {
								// If low data mode is enabled modify the SDP
								let sdpString = sdpDict.sdp
								let modifiedSDPString = self.setMediaBitrates(sdp: sdpString, videoBitrate: 2000 * 1000, audioBitrate: 200)
								// Create a new SDP using the modified SDP string
								modifiedSDP = RTCSessionDescription(type: .answer, sdp: modifiedSDPString)
							}
							self.peerConnection?.setLocalDescription(modifiedSDP, completionHandler: { (error) in
								if let error = error {
									debugPrint("peerConnection?.setLocalDescription error: \(error.localizedDescription)")
								}
							})
							let jsep = ["type": "answer", "sdp": modifiedSDP.sdp]
							self.prepareLocalJsep(jsep: jsep)
						}
					}
				}
			})
		} else {
			debugPrint("sdp jsep is nil")
		}
	}
	
	func prepareLocalJsep(jsep: [String: Any]) {
		guard let roomId = roomId else { return }
		let msg = ["request": "start", "room": NSNumber(value: roomId)] as [String: Any]
		self.janus?.send(message: msg, jsep: jsep, handleId: handleId) { (msg, _) in
			if let action = msg["started"] as? String, action == "ok" {
				debugPrint("prepareLocalJsep ok")
			}
		}
	}
	
	// MARK: - UIView Render
	func setupRemoteViewFrame(frame: CGRect) {
		videoRenderView.frame = frame
	}
	
	func removeRemoteView() {
		renderView?.removeFromSuperview()
		renderView = nil
	}
	
	public var videoRenderView: RTCMTLEAGLVideoView {
		guard let renderView = renderView else {
			let renderView = RTCMTLEAGLVideoView()
			renderView.isUserInteractionEnabled = false
			renderView.delegate = self
			if let videoTrack = self.videoTrack {
				videoTrack.add(renderView)
			}
			return renderView
		}
		return renderView
	}
}

extension JanusRoleListen: RTCVideoViewDelegate {
	public func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
		if let delegate = delegate as? JanusRoleListenDelegate {
			if renderSize == .zero {
				delegate.janusRoleListen(role: self, firstRenderWithSize: size)
			} else {
				delegate.janusRoleListen(role: self, renderSizeChangeWithSize: size)
			}
			renderSize = size
		}
	}
}

extension JanusRoleListen {
	public override func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
		asyncInMainThread { [weak self] in
			guard let self = self else { return }
			if stream.videoTracks.count > 0 {
				let videoTrack = stream.videoTracks[0]
				videoTrack.add(self.videoRenderView)
				self.videoTrack = videoTrack
			}
		}
	}
	
	public override func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
		debugPrint("")
	}
}
