//
//  CallRemoteStore.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import ChatSecure

protocol ICallRemoteStore {
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error>
}

struct CallRemoteStore {
	let callService: ICallService
}

extension CallRemoteStore: ICallRemoteStore {
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error> {
		let response = await callService.requestVideoCall(groupID: groupId, isAudioMode: isAudioCall, serverDomain: domain)
		switch response {
		case .success(let data):
			let turnServer = data.turnServer
			return .success(CallServer(groupRtcUrl: data.groupRtcURL,
									   groupRtcId: data.groupRtcID,
									   groupRtcToken: data.groupRtcToken,
									   stunServer: StunServer(server: data.stunServer.server, port: data.stunServer.port),
									   turnServer: TurnServer(server: turnServer.server, port: turnServer.port, type: turnServer.type, user: turnServer.user, pwd: turnServer.pwd))
			)
		case .failure(let error):
			return .failure(error)
		}
	}
}
