//
//  PeerCallInteractor.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import Common
import ChatSecure
import Model

protocol IPeerCallInteractor {
	var worker: IPeerCallWorker { get }
	func updateVideoCall(groupID: Int64, callType type: CallType) async -> Loadable<IPeerViewModels>
}
	
struct PeerCallInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let callService: ICallService

}

extension PeerCallInteractor: IPeerCallInteractor {
	var worker: IPeerCallWorker {
		let remoteStore = PeerCallRemoteStore(callService: callService)
		let inMemoryStore = PeerCallInMemoryStore()
		return PeerCallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore, channelStorage: channelStorage)
	}
	
	func updateVideoCall(groupID: Int64, callType type: CallType) async -> Loadable<IPeerViewModels> {
		let result = await worker.updateVideoCall(domain: channelStorage.currentServer?.serverDomain ?? "", groupID: groupID, callType: type)
		
		switch result {
		case .success(let data):
			return .loaded(PeerViewModels(callVideoModel: data))
		case .failure(let error):
			return .failed(error)
		}
	}
}

struct StubPeerCallInteractor: IPeerCallInteractor {
	let channelStorage: IChannelStorage
	let callService: ICallService
	
	var worker: IPeerCallWorker {
		let remoteStore = PeerCallRemoteStore(callService: callService)
		let inMemoryStore = PeerCallInMemoryStore()
		return PeerCallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore, channelStorage: channelStorage)
	}
	
	func updateVideoCall(groupID: Int64, callType type: CallType) async -> Loadable<IPeerViewModels> {
		let result = await worker.updateVideoCall(domain: channelStorage.currentServer?.serverDomain ?? "", groupID: groupID, callType: type)
		
		switch result {
		case .success(let data):
			return .loaded(PeerViewModels(callVideoModel: data))
		case .failure(let error):
			return .failed(error)
		}
	}
}
