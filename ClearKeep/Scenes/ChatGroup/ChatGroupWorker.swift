//
//  ChatGroupWorker.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Foundation

protocol IChatGroupWorker {
	var remoteStore: IChatGroupRemoteStore { get }
	var inMemoryStore: IChatGroupInMemoryStore { get }
}

struct ChatGroupWorker {
	let remoteStore: IChatGroupRemoteStore
	let inMemoryStore: IChatGroupInMemoryStore
	
	init(remoteStore: IChatGroupRemoteStore,
		 inMemoryStore: IChatGroupInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChatGroupWorker: IChatGroupWorker {
}
