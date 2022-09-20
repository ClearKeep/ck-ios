//
//  IPeerCallWorker.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import Model
import ChatSecure
import CommonUI
import CallManager

protocol IPeerCallWorker {
	func updateVideoCall(domain: String, groupID: Int64, callType type: CallType) async -> (Result<IVideoCallModel, Error>)
}

struct PeerCallWorker {
	let remoteStore: IPeerCallRemoteStore
	let inMemoryStore: IPeerCallInMemoryStore
	let channelStorage: IChannelStorage
	
	init(remoteStore: IPeerCallRemoteStore,
		 inMemoryStore: IPeerCallInMemoryStore,
		 channelStorage: IChannelStorage) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
		self.channelStorage = channelStorage
	}
}

extension PeerCallWorker: IPeerCallWorker {
	func updateVideoCall(domain: String, groupID: Int64, callType type: CallType) async -> (Result<IVideoCallModel, Error>) {
		let domain = channelStorage.currentDomain
		let result = await remoteStore.updateVideoCall(domain: domain, groupID: groupID, callType: type)
		
		switch result {
		case .success(let data):
			return .success(data)
		case .failure(let error):
			return .failure(error)
		}
	}
}
