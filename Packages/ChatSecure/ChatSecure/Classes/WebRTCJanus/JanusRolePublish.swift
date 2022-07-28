//
//  JanusRolePublish.swift
//  JanusWebRTC
//
//  Created by Nguyen Luan on 12/19/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import UIKit
import WebRTC

public class JanusRolePublish: JanusRole {
	public var videoRenderView: RTCMTLEAGLVideoView?
	private var channels: (video: Bool, audio: Bool, datachannel: Bool) = (true, true, true)
	private var customFrameCapturer: Bool = false
	var localVideoTrack: RTCVideoTrack!
	var localAudioTrack: RTCAudioTrack!
	
	let rtcAudioSession = RTCAudioSession.sharedInstance()
	let audioQueue = DispatchQueue(label: "audio")
	var cameraSession: CameraSession?
	var cameraFilter: CameraFilter?
	var videoCapturer: RTCVideoCapturer!
	var cameraDevicePosition: AVCaptureDevice.Position = .front
	
	override init(withJanus janus: Janus, delegate: JanusRoleDelegate? = nil, turnServer: TurnServer, stunServer: StunServer) {
		super.init(withJanus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
		self.pType = .publish
	}
	
	override class func role(withDict dict: [String: Any], janus: Janus, delegate: JanusRoleDelegate?, turnServer: TurnServer, stunServer: StunServer) -> JanusRole {
		let publish = JanusRolePublish(withJanus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
		if let username = dict["display"] as? String,
		   let videoCode = dict["video_codec"] as? String,
		   let id = dict["id"] as? Int {
			publish.id = id
			publish.display = username
			publish.audioCode = dict["audio_codec"] as? String
			publish.videoCode = videoCode
		}
		return publish
	}
	
	func startPreview() {
		//        cameraPreview.captureSession.startRunning()
	}
	
	func stopPreview() {
		//        cameraPreview.captureSession.stopRunning()
	}
	
	func setup(customFrameCapturer: Bool = true) {
		self.customFrameCapturer = customFrameCapturer
		print("--- use custom capturer ---")
		if customFrameCapturer {
			cameraSession = CameraSession()
			cameraSession?.delegate = self
			cameraSession?.setupSession()
			cameraFilter = CameraFilter()
		}
		
		videoRenderView = RTCMTLEAGLVideoView()
		videoRenderView?.delegate = self
		
		setupLocalTracks()
		configureAudioSession()
		
		if let videoRenderView = videoRenderView,
		   self.channels.video {
			if videoCapturer != nil,
			   let publishConstraints = mediaConstraints as? JanusPublishMediaConstraints {
				startCaptureLocalVideo(cameraPositon: cameraDevicePosition,
									   videoWidth: Int(publishConstraints.resolution.width),
									   videoHeight: Int(publishConstraints.resolution.height),
									   videoFps: Int(publishConstraints.fps))
				//                startCaptureLocalVideo(cameraPositon: self.cameraDevicePosition,
				//                                       videoWidth: 1280,
				//                                       videoHeight: 720,
				//                                       videoFps: 60)
			}
			localVideoTrack?.add(videoRenderView)
		}
	}
	
	func setupLocalViewFrame(frame: CGRect) {
		videoRenderView?.frame = frame
	}
	
	func captureCurrentFrame(sampleBuffer: CMSampleBuffer) {
		if let capturer = videoCapturer as? RTCCustomFrameCapturer {
			capturer.capture(sampleBuffer)
		}
	}
	
	func captureCurrentFrame(sampleBuffer: CVPixelBuffer) {
		if let capturer = videoCapturer as? RTCCustomFrameCapturer {
			capturer.capture(sampleBuffer)
		}
	}
	
	// MARK: Data Channels
	private func createDataChannel() -> RTCDataChannel? {
		let config = RTCDataChannelConfiguration()
		guard let dataChannel = peerConnection?.dataChannel(forLabel: "WebRTCData", configuration: config) else {
			debugPrint("Warning: Couldn't create data channel.")
			return nil
		}
		return dataChannel
	}
	
	func sendData(_ data: Data) {
		let buffer = RTCDataBuffer(data: data, isBinary: true)
		self.remoteDataChannel?.sendData(buffer)
	}
	
	func setupPeerStream() {
		// Video
		if channels.video, let videoTrack = localVideoTrack {
			peerConnection?.add(videoTrack, streamIds: ["stream0"])
		}
		// Audio
		if channels.audio, let audioTrack = localAudioTrack {
			peerConnection?.add(audioTrack, streamIds: ["stream0"])
		}
		// Data
		if channels.datachannel,
		   let dataChannel = createDataChannel() {
			dataChannel.delegate = self
			localDataChannel = dataChannel
		}
	}
	
	// MARK: - Override function
	override func joinRoom(withRoomId roomId: Int64, username: String?, callback: @escaping RoleJoinRoomCallback) {
		if !attached {
			attach { [weak self](error) in
				if let error = error {
					callback(error)
				} else {
					if let self = self {
						self.joinRoom(withRoomId: roomId, username: username) { (error) in
							callback(error)
						}
					} else {
						callback(JanusResultError.codeErr(code: -1, desc: "Publish attach error"))
					}
				}
			}
			return
		}
		
		setupPeerStream()
		
		super.joinRoom(withRoomId: roomId, username: username) { [weak self] (error) in
			guard let self = self else { return }
			if error == nil {
				self.sendOffer()
			}
			callback(error)
		}
	}
	
	override func leaveRoom(callback: @escaping RoleLeaveRoomCallback) {
		super.leaveRoom { [weak self] in
			guard let self = self else { return }
			self.destroyRTCPeer()
			DispatchQueue.main.async {
				self.videoRenderView?.removeFromSuperview()
				self.localVideoTrack = nil
				self.videoRenderView = nil
			}
			callback()
		}
	}
	
	override func handleRemote(jsep: [String: Any]) {
		guard let sdp = jsep["sdp"] as? String else { return }
		var sdpType: RTCSdpType = .answer
		if let type = jsep["type"] as? String, type == "offer" {
			sdpType = .offer
		}
		let sessionDest = RTCSessionDescription(type: sdpType, sdp: sdp)
		self.peerConnection?.setRemoteDescription(sessionDest) { (error) in
			if let error = error {
				debugPrint("Publish Role setRemoteDescription error: \(String(describing: error.localizedDescription))")
			}
		}
	}
	
	override func pluginHandle(message msg: [String: Any], jsep: [String: Any]?, transaction: String?) {
		guard let event = msg["videoroom"] as? String else { return }
		if event == "event" {
			if let publishers = msg["publishers"] as? [[String: Any]] {
				for item in publishers {
					if let delegate = self.delegate as? JanusRoleListenDelegate,
					   let janus = janus {
						let listener = JanusRoleListen.role(withDict: item, janus: janus, delegate: delegate, turnServer: turnServer, stunServer: stunServer)
						listener.privateId = self.privateId
						listener.opaqueId = self.opaqueId
						delegate.janusRole(role: self, didJoinRemoteRole: listener)
					}
				}
			} else if let leaving = msg["leaving"] as? Int {
				if let delegate = self.delegate as? JanusRoleListenDelegate {
					delegate.janusRole(role: self, didLeaveRemoteRoleWithUid: leaving)
				}
			} else if let unpublished = msg["unpublished"] as? Int {
				if let delegate = self.delegate as? JanusRoleListenDelegate {
					delegate.janusRole(role: self, remoteUnPublishedWithUid: unpublished)
				}
			}
		}
	}
}

// MARK: Private function
private extension JanusRolePublish {
	func configureAudioSession() {
		self.rtcAudioSession.lockForConfiguration()
		do {
			try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
			try self.rtcAudioSession.setMode(AVAudioSession.Mode.voiceChat.rawValue)
		} catch let error {
			debugPrint("Error changeing AVAudioSession category: \(error)")
		}
		self.rtcAudioSession.unlockForConfiguration()
	}
	
	func setupLocalTracks() {
		if self.channels.video == true {
			self.localVideoTrack = createVideoTrack()
		}
		if self.channels.audio == true {
			self.localAudioTrack = createAudioTrack()
		}
	}
	
	func createAudioTrack() -> RTCAudioTrack {
		let audioSource = RTCFactory.shared.peerConnectionFactory().audioSource(with: mediaConstraints?.getAudioConstraints())
		let audioTrack = RTCFactory.shared.peerConnectionFactory().audioTrack(with: audioSource, trackId: "audio0")
		return audioTrack
	}
	
	func createVideoTrack() -> RTCVideoTrack? {
		guard let publishConstraints = mediaConstraints as? JanusPublishMediaConstraints else { return nil }
		let videoSource = RTCFactory.shared.peerConnectionFactory().videoSource()
		videoSource.adaptOutputFormat(toWidth: Int32(publishConstraints.resolution.width),
									  height: Int32(publishConstraints.resolution.height),
									  fps: publishConstraints.fps)
		if customFrameCapturer {
			videoCapturer = RTCCustomFrameCapturer(delegate: videoSource)
		} else if TARGET_OS_SIMULATOR != 0 {
			print("now runnnig on simulator...")
			videoCapturer = RTCFileVideoCapturer(delegate: videoSource)
		} else {
			videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
		}
		let videoTrack = RTCFactory.shared.peerConnectionFactory().videoTrack(with: videoSource, trackId: "video0")
		return videoTrack
	}
	
	func stopVideoCapture() {
		if let capturer = videoCapturer as? RTCCameraVideoCapturer {
			capturer.captureSession.stopRunning()
		} else if videoCapturer != nil {
			cameraSession?.stopSession()
		}
	}
	
	func sendOffer() {
		guard let constraints = mediaConstraints?.getOfferConstraints() else {
			return
		}
		peerConnection?.offer(for: constraints, completionHandler: { [weak self] (sdp, error) in
			guard let self = self else { return }
			if error == nil, let sdp = sdp, let videoCode = self.mediaConstraints?.videoCode {
				//                let sdpPreferringCodec = descriptionForDescription(description: sdp,
				//                                                                   preferredForDescription: videoCode)
				guard let sdpPreferringCodec = Tools.description(for: sdp, preferredVideoCodec: videoCode),
					  let publishMediaConstraints = self.mediaConstraints as? JanusPublishMediaConstraints else {
						  print("Tools.description fail")
						  return
					  }
				var modifiedSDP = sdpPreferringCodec
				let lowDataModeEnabled = false
				if lowDataModeEnabled {
					// If low data mode is enabled modify the SDP
					let sdpString = sdpPreferringCodec.sdp
					let modifiedSDPString = self.setMediaBitrates(sdp: sdpString, videoBitrate: (publishMediaConstraints.videoBitrate * 1000), audioBitrate: 200)
					// Create a new SDP using the modified SDP string
					modifiedSDP = RTCSessionDescription(type: .offer, sdp: modifiedSDPString)
				}
				
				self.peerConnection?.setLocalDescription(modifiedSDP, completionHandler: { [weak self] (error) in
					guard let self = self else { return }
					if let error = error {
						debugPrint("Publish Role setLocalDescription error: \(String(describing: error.localizedDescription))")
					} else {
						let jsep = ["type": "offer", "sdp": modifiedSDP.sdp]
						let msg = ["request": "configure",
								   "audio": NSNumber(value: true),
								   "video": NSNumber(value: true),
								   "bitrate": NSNumber(value: publishMediaConstraints.videoBitrate * 1000)] as [String: Any]
						self.janus?.send(message: msg, jsep: jsep, handleId: self.handleId, callback: { [weak self] (msg, jsep) in
							if let self = self,
							   let status = msg["configured"] as? String, status == "ok" {
								if let jsep = jsep {
									self.handleRemote(jsep: jsep)
								}
							}
						})
					}
				})
				self.configBitrate()
			}
		})
	}
	
	func configBitrate() {
		if let publishMediaConstraints = self.mediaConstraints as? JanusPublishMediaConstraints {
			if publishMediaConstraints.videoBitrate > 0 {
				debugPrint("configBitrate senders: \(self.peerConnection?.senders.count)")
				guard let peerConnection = self.peerConnection else { return }
				for sender in peerConnection.senders {
					if let track = sender.track {
						if track.kind == kARDVideoTrackKind {
							let paramsToModify = sender.parameters
							for encoding in paramsToModify.encodings {
								encoding.maxBitrateBps = NSNumber(value: publishMediaConstraints.videoBitrate * 1000)
							}
							sender.parameters = paramsToModify
						}
					}
				}
			}
		}
	}
}

// MARK: - RTCVideoViewDelegate
extension JanusRolePublish: RTCVideoViewDelegate {
	public func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
		let isLandScape = size.width < size.height
		var renderView: RTCMTLEAGLVideoView?
		var parentView: UIView?
		if videoView.isEqual(videoRenderView) {
			print("local video size changed")
			renderView = videoRenderView
			parentView = videoRenderView?.superview
		}
		
		guard let renderView = renderView, let parentView = parentView else { return }
		
		if isLandScape {
			let ratio = size.width / size.height
			renderView.frame = CGRect(x: 0, y: 0, width: parentView.frame.height * ratio, height: parentView.frame.height)
			renderView.center.x = parentView.frame.width / 2
		} else {
			let ratio = size.height / size.width
			renderView.frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.width * ratio)
			renderView.center.y = parentView.frame.height / 2
		}
	}
}

// MARK: - RTCDataChannelDelegate
extension JanusRolePublish: RTCDataChannelDelegate {
	public func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
		debugPrint("dataChannel did change state: \(dataChannel.readyState)")
	}
	
	public func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
		if let delegate = delegate as? JanusRoleDelegate {
			delegate.janusRole(role: self, didReceiveData: buffer.data)
		}
	}
}

// MARK: - CameraSessionDelegate
extension JanusRolePublish: CameraSessionDelegate {
	func didOutput(_ sampleBuffer: CMSampleBuffer) {
		if customFrameCapturer {
			if let cvpixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
				if let buffer = cameraFilter?.apply(cvpixelBuffer) {
					captureCurrentFrame(sampleBuffer: buffer)
					return
				} else {
					print("no applied image")
				}
			} else {
				print("no pixelbuffer")
			}
			captureCurrentFrame(sampleBuffer: sampleBuffer)
		}
	}
}
