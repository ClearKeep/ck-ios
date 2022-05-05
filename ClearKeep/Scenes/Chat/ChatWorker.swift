//
//  ChatWorker.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Foundation

protocol IChatWorker {
	var remoteStore: IChatRemoteStore { get }
	var inMemoryStore: IChatInMemoryStore { get }
}

struct ChatWorker {
	let remoteStore: IChatRemoteStore
	let inMemoryStore: IChatInMemoryStore
	
	init(remoteStore: IChatRemoteStore,
		 inMemoryStore: IChatInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChatWorker: IChatWorker {
}
