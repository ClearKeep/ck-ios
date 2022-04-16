//
//  ChatMessageWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 30/03/2022.
//

import Foundation

protocol IChatMessageWorker {
	var remoteStore: IChatMessageRemoteStore { get }
	var inMemoryStore: IChatMessageInMemoryStore { get }
}

struct ChatMessageWorker {
	let remoteStore: IChatMessageRemoteStore
	let inMemoryStore: IChatMessageInMemoryStore
	
	init(remoteStore: IChatMessageRemoteStore,
		 inMemoryStore: IChatMessageInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChatMessageWorker: IChatMessageWorker {
}
