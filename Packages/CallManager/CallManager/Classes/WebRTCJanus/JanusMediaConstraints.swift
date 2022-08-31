//
//  JanusMediaConstraints.swift
//  JanusWebRTC
//
//  Created by Nguyen Luan on 12/19/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import UIKit
import WebRTC

class JanusMediaConstraints: NSObject {
	var videoEnable = true
	var audioEnable = true
	var videoCode = "H264"
	var shouldUseLevelControl = false
	
	func getOfferConstraints() -> RTCMediaConstraints {
		let mandatoryConstraints = ["OfferToReceiveAudio": audioEnable ? "true" : "false",
									"OfferToReceiveVideo": videoEnable ? "true" : "false"]
		return RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: nil)
	}
	
	func getAudioConstraints() -> RTCMediaConstraints {
		return RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
	}
	
	func getAnswerConstraints() -> RTCMediaConstraints {
		let mandatoryConstraints = ["OfferToReceiveAudio": videoEnable ? "true" : "false",
									"OfferToReceiveVideo": audioEnable ? "true" : "false"]
		return RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: nil)
	}
	
	func getPeerConnectionConstraints() -> RTCMediaConstraints {
		let optionalConstraints = ["DtlsSrtpKeyAgreement": "true", "googSuspendBelowMinBitrate": "false", "googCombinedAudioVideoBwe": "true"]
		return RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: optionalConstraints)
	}
}

class JanusPublishMediaConstraints: JanusMediaConstraints {
	var resolution: CGSize = .zero
	var fps: Int32 = 60
	var frequency: Int = 0
	var videoBitrate: Int = 0
	var audioBirate: Int = 0
}
