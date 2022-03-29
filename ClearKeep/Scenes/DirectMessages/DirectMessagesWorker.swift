//
//  DirectMessagesWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 29/03/2022.
//

import Foundation

protocol IDirectMessagesWorker {
	var remoteStore: IDirectMessagesRemoteStore { get }
	var inMemoryStore: IDirectMessagesInMemoryStore { get }
}

struct DirectMessagesWorker {
	let remoteStore: IDirectMessagesRemoteStore
	let inMemoryStore: IDirectMessagesInMemoryStore
	
	init(remoteStore: IDirectMessagesRemoteStore,
		 inMemoryStore: IDirectMessagesInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension DirectMessagesWorker: IDirectMessagesWorker {
}
