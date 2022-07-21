//
//  CallService.swift
//  ChatSecure
//
//  Created by Quang Pham on 21/07/2022.
//

import Networking
import Common

public protocol ICallService {
	func requestVideoCall(groupID: Int64, isAudioMode: Bool, serverDomain: String) async -> Result<VideoCall_ServerResponse, Error>
}

public class CallService {
	public init() {
	}
}

extension CallService: ICallService {
	public func requestVideoCall(groupID: Int64, isAudioMode: Bool, serverDomain: String) async -> Result<VideoCall_ServerResponse, Error> {
		var request = VideoCall_VideoCallRequest()
		request.groupID = groupID
		request.callType = isAudioMode ? "audio" : "video"
		
		return await channelStorage.getChannel(domain: serverDomain).videoCall(request)
	}
}
