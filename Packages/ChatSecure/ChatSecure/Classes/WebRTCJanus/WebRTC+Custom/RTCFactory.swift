//
//  RTCFactory.swift
//  GoogleWebRTCJanus
//
//  Created by VietAnh on 12/23/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable force_unwrapping
import WebRTC

class RTCFactory: NSObject {
	private var _peerConnectionFactory: RTCPeerConnectionFactory?
	
	static let shared = RTCFactory()
	
	func peerConnectionFactory() -> RTCPeerConnectionFactory {
		if _peerConnectionFactory == nil {
			var videoEncoderFactory = RTCDefaultVideoEncoderFactory()
			var videoDecoderFactory = RTCDefaultVideoDecoderFactory()
			if TARGET_OS_SIMULATOR != 0 {
				videoEncoderFactory = RTCSimluatorVideoEncoderFactory()
				videoDecoderFactory = RTCSimulatorVideoDecoderFactory()
			}
			_peerConnectionFactory = RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
		}
		return _peerConnectionFactory!
	}
}
