//
//  CallService.swift
//  _NIODataStructures
//
//  Created by HOANDHTB on 25/07/2022.
//

import Foundation
import Networking
import CryptoSwift

public protocol ICallService {
	func updateVideoCall(_ groupID: Int64, callType type: String, domain: String) async -> (Result<VideoCall_BaseResponse, Error>)
}

public class CallService {
	public init() {
	}
}

extension CallService: ICallService {
	public func updateVideoCall(_ groupID: Int64, callType type: String, domain: String) async -> (Result<VideoCall_BaseResponse, Error>) {
		var callRequest = VideoCall_UpdateCallRequest()
		callRequest.groupID = groupID
		callRequest.updateType = type
		
		return await channelStorage.getChannel(domain: domain).updateCall(callRequest)
	}
}
