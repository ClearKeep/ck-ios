//
//  PeerCallRemoteStore.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import UIKit
import ChatSecure
import Model
import Networking

protocol IPeerCallRemoteStore {
	func updateVideoCall(domain: String, groupID: Int64, callType type: CallType) async -> (Result<IVideoCallModel, Error>)
}

struct PeerCallRemoteStore {
	let callService: ICallService
}

extension PeerCallRemoteStore: IPeerCallRemoteStore {
	func updateVideoCall(domain: String, groupID: Int64, callType type: CallType) async -> (Result<IVideoCallModel, Error>) {
		let result = await callService.updateVideoCall(groupID, callType: type.rawValue, domain: domain)
		
		switch result {
		case .success(let response):
			 let change = ChangeTypeCall(data: response)
			return .success(change)
		case .failure(let error):
			return .failure(error)
		}
	}
}
