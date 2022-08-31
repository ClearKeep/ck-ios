//
//  RTCCustomFrameCapturer.swift
//  GoogleWebRTCJanus
//
//  Created by VietAnh on 12/23/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import Foundation
import WebRTC

class RTCCustomFrameCapturer: RTCVideoCapturer {
	let kNanosecondsPerSecond: Float64 = 1000000000
	var nanoseconds: Float64 = 0
	
	override init(delegate: RTCVideoCapturerDelegate) {
		super.init(delegate: delegate)
	}
	
	public func capture(_ sampleBuffer: CMSampleBuffer) {
		if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
			let rtcPixelBuffer = RTCCVPixelBuffer(pixelBuffer: pixelBuffer)
			let timeStampNs = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * kNanosecondsPerSecond
			let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixelBuffer, rotation: RTCVideoRotation._90, timeStampNs: Int64(timeStampNs))
			delegate?.capturer(self, didCapture: rtcVideoFrame)
		}
	}
	
	public func capture(_ pixelBuffer: CVPixelBuffer) {
		let rtcPixelBuffer = RTCCVPixelBuffer(pixelBuffer: pixelBuffer)
		let timeStampNs = nanoseconds * kNanosecondsPerSecond
		
		let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixelBuffer, rotation: RTCVideoRotation._90, timeStampNs: Int64(timeStampNs))
		delegate?.capturer(self, didCapture: rtcVideoFrame)
		nanoseconds += 1
	}
}
