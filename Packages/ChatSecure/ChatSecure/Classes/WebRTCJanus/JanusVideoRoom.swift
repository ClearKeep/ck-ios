//
//  JanusVideoRoom.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/21/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable weak_delegate class_delegate_protocol

import UIKit
import AVFoundation
import WebRTC

protocol JanusVideoRoomDelegate: NSObject {
	func janusVideoRoom(janusRoom: JanusVideoRoom, didJoinRoomWithId clientId: Int)
	func janusVideoRoom(janusRoom: JanusVideoRoom, remoteLeaveWithID clientId: Int)
	func janusVideoRoom(janusRoom: JanusVideoRoom, remoteUnPublishedWithUid clientId: Int)
	func janusVideoRoom(janusRoom: JanusVideoRoom, firstFrameDecodeWithSize size: CGSize, uId: Int)
	func janusVideoRoom(janusRoom: JanusVideoRoom, renderSizeChangeWithSize size: CGSize, uId: Int)
}

extension JanusVideoRoomDelegate {
	func janusVideoRoom(janusRoom: JanusVideoRoom, didSetRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) { }
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, didSetLocalVideoTrack localVideoTrack: RTCVideoTrack) { }
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, newRemoteJoinWithID clientId: Int) { }
	
	func janusVideoRoomDidLeaveRoom(janusRoom: JanusVideoRoom) { }
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, fatalErrorWithID code: RTCErrorCode) { }
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, netBrokenWithID reason: RTCNetBrokenReason) { }
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, didReceiveData data: Data) {}
}

public class JanusVideoRoom: NSObject {
	var delegate: JanusVideoRoomDelegate?
	public var remotes = [Int: JanusRoleListen]()
	///  TODO: add config
	public var publisher: JanusRolePublish?
	var canvas = [Int: RTCCanvas]()
	
	private var userId: Int = 0
	private var username: String?
	private var roomId: Int64 = 0
	var useCustomCapturer = false
	
	init(delegate: JanusVideoRoomDelegate? = nil, token: String?, rtcUrl: String) {
		super.init()
		//        let server = URL(string: "ws://54.235.68.160:8188/janus") // staging server
		let server = URL(string: rtcUrl) // dev server
		//        let server = URL(string: "ws://10.0.255.82:8188/janus") // Local server
		
		//        let server = URL(string: AppConfig.buildEnvironment.webrtc)
		
		guard let server = server else {
			return
		}
		
		let janus = Janus(withServer: server, token: token)
		publisher = JanusRolePublish(withJanus: janus, delegate: self)
		
		self.delegate = delegate
		let localConfig = JanusPublishMediaConstraints()
		//        localConfig.resolution = CGSize(width: 4032, height: 3024)
		localConfig.resolution = CGSize(width: 1280, height: 720)
		//        localConfig.resolution = CGSize(width: 1024, height: 768)
		//        localConfig.resolution = CGSize(width: 960, height: 540)
		//        localConfig.resolution = CGSize(width: 640, height: 480)
		//        localConfig.resolution = CGSize(width: 480, height: 640)
		//        localConfig.resolution = CGSize(width: 192, height: 144)
		localConfig.fps = 30
		localConfig.videoBitrate = 512
		localConfig.audioBirate = 200
		localConfig.frequency = 44100
		publisher?.mediaConstraints = localConfig
		publisher?.setup(customFrameCapturer: useCustomCapturer)
	}
	
	func joinRoom(withRoomId roomId: Int64,
				  username: String,
				  completeCallback callback: CompleteCallback?) {
		self.roomId = roomId
		self.username = username
		AVCaptureDevice.authorizeVideo(completion: { (status) in
			AVCaptureDevice.authorizeAudio(completion: { (status) in
				if status == .alreadyAuthorized || status == .justAuthorized {
					self.publisher?.joinRoom(withRoomId: roomId, username: username, callback: { [weak self] error in
						guard let self = self else { return }
						if let callback = callback {
							callback(error == nil, error)
						} else {
							asyncInMainThread {
								if let publisherId = self.publisher?.id {
									self.delegate?.janusVideoRoom(janusRoom: self, didJoinRoomWithId: publisherId)
								}
							}
						}
					})
				} else {
					print("Permission authorizeAudio denied")
					if let callbackJoin = callback {
						callbackJoin(false, nil)
					} else {
						self.delegate?.janusVideoRoom(janusRoom: self, fatalErrorWithID: .permission)
					}
				}
			})
		})
	}
	
	func leaveRoom(callback: (() -> Void)?) {
		for listenRole in remotes.values {
			listenRole.leaveRoom {
				//                let _ = self?.stopPreView(withUid: listenRole.id!)
				DispatchQueue.main.async {
					listenRole.renderView?.removeFromSuperview()
					listenRole.videoTrack = nil
					listenRole.renderView = nil
				}
			}
		}
		publisher?.leaveRoom { [weak self] in
			guard let self = self else { return }
			asyncInMainThread {
				if let callback = callback {
					callback()
				} else {
					self.delegate?.janusVideoRoomDidLeaveRoom(janusRoom: self)
				}
			}
		}
	}
	
	func startListenRemote(remoteRole: JanusRoleListen) {
		guard let remoteRoleId = remoteRole.id else { return }
		
		self.remotes[remoteRoleId] = remoteRole
		remoteRole.joinRoom(withRoomId: roomId, username: nil) { [weak self] _ in
			guard let self = self else { return }
			asyncInMainThread {
				self.delegate?.janusVideoRoom(janusRoom: self, newRemoteJoinWithID: remoteRoleId)
			}
		}
	}
	
	func stopListenRemote(remoteRole: JanusRoleListen) {
		guard let remoteRoleId = remoteRole.id else { return }
		
		self.remotes.removeValue(forKey: remoteRoleId)
	}
	
	deinit {
		self.publisher?.janus?.destroySession()
	}
}

extension JanusVideoRoom: JanusRoleListenDelegate {
	
	func janusRoleListen(role: JanusRoleListen, firstRenderWithSize size: CGSize) {
		guard let roleId = role.id else { return }
		
		self.delegate?.janusVideoRoom(janusRoom: self, firstFrameDecodeWithSize: size, uId: roleId)
	}
	
	func janusRoleListen(role: JanusRoleListen, renderSizeChangeWithSize size: CGSize) {
		guard let roleId = role.id else { return }
		
		self.delegate?.janusVideoRoom(janusRoom: self, renderSizeChangeWithSize: size, uId: roleId)
	}
	
	func janusRole(role: JanusRole, fatalErrorWithID code: RTCErrorCode) {
		self.delegate?.janusVideoRoom(janusRoom: self, fatalErrorWithID: code)
	}
	
	func janusRole(role: JanusRole, netBrokenWithID reason: RTCNetBrokenReason) {
		self.leaveRoom(callback: nil)
		asyncInMainThread {
			self.delegate?.janusVideoRoom(janusRoom: self, netBrokenWithID: reason)
		}
	}
	
	func janusRole(role: JanusRole, joinRoomWithResult error: Error?) {
		guard let roleId = role.id else { return }
		
		if let publisher = self.publisher {
			if roleId == publisher.id {
				asyncInMainThread {
					self.delegate?.janusVideoRoom(janusRoom: self, didJoinRoomWithId: roleId)
				}
			}
		}
	}
	
	func janusRole(role: JanusRole, leaveRoomWithResult error: Error?) {
		if let publisher = self.publisher {
			if role.id == publisher.id {
				publisher.janus?.destroySession()
				publisher.janus?.stop()
			}
		}
		self.remotes.removeAll()
	}
	
	func janusRole(role: JanusRole?, didJoinRemoteRole remoteRole: JanusRoleListen) {
		for role in self.remotes.values where remoteRole.id == role.id {
			return
		}
		self.startListenRemote(remoteRole: remoteRole)
	}
	
	func janusRole(role: JanusRole, didLeaveRemoteRoleWithUid uid: Int) {
		if let leaveRole = self.remotes[uid] {
			self.remotes.removeValue(forKey: uid)
			leaveRole.detach(withCallback: nil)
			asyncInMainThread {
				self.delegate?.janusVideoRoom(janusRoom: self, remoteLeaveWithID: uid)
			}
		}
	}
	
	func janusRole(role: JanusRole, remoteDetachWithUid uid: Int) {
		if let leaveRole = self.remotes[uid] {
			self.remotes.removeValue(forKey: uid)
			leaveRole.detach(withCallback: nil)
			asyncInMainThread {
				self.delegate?.janusVideoRoom(janusRoom: self, remoteLeaveWithID: uid)
			}
		}
	}
	
	func janusRole(role: JanusRole, remoteUnPublishedWithUid uid: Int) {
		self.delegate?.janusVideoRoom(janusRoom: self, remoteUnPublishedWithUid: uid)
	}
	
	func janusRole(role: JanusRole, didReceiveData data: Data) {
		self.delegate?.janusVideoRoom(janusRoom: self, didReceiveData: data)
	}
}

public extension AVCaptureDevice {
	enum AuthorizationStatus {
		case justDenied
		case alreadyDenied
		case restricted
		case justAuthorized
		case alreadyAuthorized
		case unknown
	}
	
	class func authorizeVideo(completion: ((AuthorizationStatus) -> Void)?) {
		AVCaptureDevice.authorize(mediaType: AVMediaType.video, completion: completion)
	}
	
	class func authorizeAudio(completion: ((AuthorizationStatus) -> Void)?) {
		AVCaptureDevice.authorize(mediaType: AVMediaType.audio, completion: completion)
	}
	
	private class func authorize(mediaType: AVMediaType, completion: ((AuthorizationStatus) -> Void)?) {
		let status = AVCaptureDevice.authorizationStatus(for: mediaType)
		switch status {
		case .authorized:
			completion?(.alreadyAuthorized)
		case .denied:
			completion?(.alreadyDenied)
		case .restricted:
			completion?(.restricted)
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
				DispatchQueue.main.async {
					if granted {
						completion?(.justAuthorized)
					} else {
						completion?(.justDenied)
					}
				}
			})
		@unknown default:
			completion?(.unknown)
		}
	}
}
