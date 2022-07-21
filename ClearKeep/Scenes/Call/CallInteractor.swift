//
//  CallInteractor.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import Common
import ChatSecure

protocol ICallInteractor {
	var worker: ICallWorker { get }
	func requestCall(groupId: Int64, isAudioCall: Bool) async

}

struct CallInteractor {
	let appState: Store<AppState>
	let callService: ICallService
	let channelStorage: IChannelStorage

}

extension CallInteractor: ICallInteractor {
	var worker: ICallWorker {
		let remoteStore = CallRemoteStore(callService: callService)
		let inMemoryStore = CallInMemoryStore()
		return CallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func requestCall(groupId: Int64, isAudioCall: Bool) async {
		guard let domain = channelStorage.currentServer?.serverDomain else { return }
		let result = await worker.requestCall(groupId: groupId, isAudioCall: isAudioCall, domain: domain)
		switch result {
		case .success(let data):
			print(data)
			CallManager.shared.startCall(
				clientId: "8ef8cfa8-ef0a-43a5-8e2e-8b93499c1730",
				clientName: "8ef8cfa8-ef0a-43a5-8e2e-8b93499c1730",
				avatar: nil,
				callserver: data,
				isCallGroup: false)
		case .failure(let error):
			print(error)
		}
	}

}

struct StubCallInteractor: ICallInteractor {
	
	let callService: ICallService
	
	var worker: ICallWorker {
		let remoteStore = CallRemoteStore(callService: callService)
		let inMemoryStore = CallInMemoryStore()
		return CallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func requestCall(groupId: Int64, isAudioCall: Bool) async {
		
	}
}
