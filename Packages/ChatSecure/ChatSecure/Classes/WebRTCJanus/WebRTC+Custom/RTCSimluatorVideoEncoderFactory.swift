//
//  RTCSimluatorVideoEncoderFactory.swift
//  GoogleWebRTCJanus
//
//  Created by VietAnh on 12/23/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import Foundation
import WebRTC

class RTCSimluatorVideoEncoderFactory: RTCDefaultVideoEncoderFactory {
	override init() {
		super.init()
	}
	
	override class func supportedCodecs() -> [RTCVideoCodecInfo] {
		var codecs = super.supportedCodecs()
		codecs = codecs.filter { $0.name != "H264" }
		return codecs
	}
}
