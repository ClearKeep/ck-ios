//
//  CallWorker.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import ChatSecure

protocol ICallWorker {
	var remoteStore: ICallRemoteStore { get }
	var inMemoryStore: ICallInMemoryStore { get }
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error>

}

struct CallWorker {
	let remoteStore: ICallRemoteStore
	let inMemoryStore: ICallInMemoryStore
	
	init(remoteStore: ICallRemoteStore,
		 inMemoryStore: ICallInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension CallWorker: ICallWorker {
	func requestCall(groupId: Int64, isAudioCall: Bool, domain: String) async -> Result<CallServer, Error> {
		return await remoteStore.requestCall(groupId: groupId, isAudioCall: isAudioCall, domain: domain)
	}

}
