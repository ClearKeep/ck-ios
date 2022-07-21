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
	func startVideo(ourClientId: String, janusGroupId: Int, janusUrl: String, stunUrl: String, turnUrl: String, turnUser: String, turnPass: String, token: String)
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
	
	public func startVideo(ourClientId: String, janusGroupId: Int, janusUrl: String, stunUrl: String, turnUrl: String, turnUser: String, turnPass: String, token: String) {
		Debug.DLog("startVideo: stun = \(stunUrl), turn = \(turnUrl), username = \(turnUser), pwd = \(turnPass), group = \(janusGroupId), token = \(token) Janus URL: \(janusUrl)")
		
	}
}
