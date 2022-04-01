//
//  ChatGroupWorker.swift
//  ClearKeep
//
//  Created by đông on 01/04/2022.
//

import UIKit
import Combine
import Common

protocol IChatGroupWorker {
	var remoteStore: IChatGroupRemoteStore { get }
	var inMemoryStore: IChatGroupInMemoryStore { get }
}

struct ChatGroupWorker {
	let remoteStore: IChatGroupRemoteStore
	let inMemoryStore: IChatGroupInMemoryStore

	init(remoteStore: IChatGroupRemoteStore, inMemoryStore: IChatGroupInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChatGroupWorker: IChatGroupWorker {
}
