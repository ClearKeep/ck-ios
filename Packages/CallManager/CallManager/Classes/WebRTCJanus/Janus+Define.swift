//
//  JanusDefine.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/18/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable class_delegate_protocol

import Foundation
import UIKit

// MARK: - RTC Enum
enum RTCVideoRoomErrorCode: Int {
	case unknow = 499
	case noMessage = 421
	case invalidJson = 422
	case invalidRequest = 423
	case joinFirst = 424
	case alreadyJoined = 425
	case noSuchFeed = 428
	case missingElement = 429
	case invalidElement = 430
	case invalidSdpType = 431
	case publishersFull = 432
	case unauthorized = 433
	case alreadyPublished = 434
	case noPublished = 435
	case idExist = 436
	case invalidSdp = 437
}

enum RTCErrorCode: Int {
	case unknow = 0
	case serverJsonErr = -1
	case serverErr = -2
	case permission = -3
}

enum RTCNetBrokenReason: Int {
	case unknow = 0
	case websocketFail = -1
	case websocketClose = -2
}

enum RTCMediaType {
	case video
	case audio
	case data
}

enum RTCRenderMode: Int {
	case hidden = 1
	case fit = 2
	case fill = 3
}

// MARK: - Janus define
typealias SuccessCallback = () -> Void
typealias FailureCallback = (Error) -> Void
typealias CompleteCallback = (Bool, Error?) -> Void
typealias AttachCallback = (NSNumber, Error?) -> Void
typealias DetachCallback = (Error?) -> Void
typealias PluginRequestCallback = ([String: Any], [String: Any]?) -> Void
typealias JanusRequestCallback = ([String: Any]) -> Void

protocol JanusDelegate {
	func janus(_ janus: Janus, createComplete error: Error?)
	func janus(_ janus: Janus, attachPlugin handleId: NSNumber, result error: Error?)
	func janus(_ janus: Janus, netBrokenWithId reason: RTCNetBrokenReason)
	func janusDestroy(_ janus: Janus?)
}

enum JanusMessage: String {
	case create
	case attach
	case detach
	case destroy
	case message
	case trickle
	case keepalive
	case success
	case ack
	case event
	case webrtcup
	case media
	case error
	case slowlink
	case hangup
	case deteched
	case timeout
}

enum JanusResultError: Error {
	case noErr
	case jsonErr(msg: String?)
	case funcErr(msg: String?)
	case codeErr(code: Int, desc: String?)
}

let kARDMediaStreamId = "ARDAMS"
let kARDAudioTrackId = "ARDAMSa0"
let kARDVideoTrackId = "ARDAMSv0"
let kARDVideoTrackKind = "video"
