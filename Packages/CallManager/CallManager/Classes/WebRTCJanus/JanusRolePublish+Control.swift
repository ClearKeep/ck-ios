//
//  JanusRolePublish+Control.swift
//  GoogleWebRTCJanus
//
//  Created by VietAnh on 12/28/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import Foundation
import WebRTC

public extension JanusRolePublish {
	func muteAudio() {
		self.setAudioEnabled(false)
	}
	
	func unmuteAudio() {
		self.setAudioEnabled(true)
	}
	
	func cameraOff() {
		self.localVideoTrack.isEnabled = false
	}
	
	func cameraOn() {
		self.localVideoTrack.isEnabled = true
	}
	
	func speakerOff() {
		self.audioQueue.async { [weak self] in
			guard let self = self else {
				return
			}
			
			self.rtcAudioSession.lockForConfiguration()
			do {
				try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
				try self.rtcAudioSession.overrideOutputAudioPort(.none)
			} catch let error {
				debugPrint("Error setting AVAudioSession category: \(error)")
			}
			self.rtcAudioSession.unlockForConfiguration()
		}
	}
	
	// Force speaker
	func speakerOn() {
		self.audioQueue.async { [weak self] in
			guard let self = self else {
				return
			}
			
			self.rtcAudioSession.lockForConfiguration()
			do {
				try self.rtcAudioSession.setCategory(AVAudioSession.Category.playAndRecord.rawValue)
				try self.rtcAudioSession.overrideOutputAudioPort(.speaker)
				try self.rtcAudioSession.setActive(true)
			} catch let error {
				debugPrint("Couldn't force audio to speaker: \(error)")
			}
			self.rtcAudioSession.unlockForConfiguration()
		}
	}
	
	public func switchCameraPosition() {
		if let capturer = self.videoCapturer as? RTCCameraVideoCapturer,
		   let publishConstraints = self.mediaConstraints as? JanusPublishMediaConstraints {
			capturer.stopCapture {
				let position = (self.cameraDevicePosition == .front) ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
				self.cameraDevicePosition = position
				let cameraWidth = self.cameraDevicePosition == .front ? publishConstraints.resolution.width : 1024
				let cameraHeight = self.cameraDevicePosition == .front ? publishConstraints.resolution.height : 768
				self.startCaptureLocalVideo(cameraPositon: position,
											videoWidth: Int(cameraWidth),
											videoHeight: Int(cameraHeight),
											videoFps: Int(publishConstraints.fps))
			}
		} else if videoCapturer != nil {
			let position = (self.cameraDevicePosition == .front) ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
			self.cameraDevicePosition = position
			cameraSession?.setupSession(position: position)
		}
	}
	
	func startCaptureLocalVideo(cameraPositon: AVCaptureDevice.Position, videoWidth: Int, videoHeight: Int, videoFps: Int) {
		if let capturer = self.videoCapturer as? RTCCameraVideoCapturer {
			var targetDevice: AVCaptureDevice?
			var targetFormat: AVCaptureDevice.Format?
			
			// find target device
			let devicies = RTCCameraVideoCapturer.captureDevices()
			devicies.forEach { (device) in
				if device.position == cameraPositon {
					targetDevice = device
				}
			}
			guard let targDevice = targetDevice else { return }
			
			// find target format
			let formats = RTCCameraVideoCapturer.supportedFormats(for: targDevice)
			formats.forEach { (format) in
				for _ in format.videoSupportedFrameRateRanges {
					let description = format.formatDescription as CMFormatDescription
					let dimensions = CMVideoFormatDescriptionGetDimensions(description)
					
					if dimensions.width == videoWidth && dimensions.height == videoHeight {
						targetFormat = format
					} else if dimensions.width == videoWidth {
						targetFormat = format
					}
				}
			}
			
			guard let targetFormat = targetFormat else { return }
			
			capturer.startCapture(with: targDevice,
								  format: targetFormat,
								  fps: videoFps)
		} else if let capturer = videoCapturer as? RTCFileVideoCapturer {
			print("setup file video capturer")
			if Bundle.main.path(forResource: "sample.mp4", ofType: nil) != nil {
				capturer.startCapturing(fromFileNamed: "sample.mp4") { (err) in
					print(err)
				}
			} else {
				print("file did not faund")
			}
		}
	}
	
	private func setAudioEnabled(_ isEnabled: Bool) {
		localAudioTrack.isEnabled = isEnabled
	}
}
