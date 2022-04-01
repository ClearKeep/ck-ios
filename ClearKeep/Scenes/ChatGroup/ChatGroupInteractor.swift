//
//  ChatGroupInteractor.swift
//  ClearKeep
//
//  Created by đông on 01/04/2022.
//

import Common

protocol IChatGroupInteractor {
	var worker: IChatGroupWorker { get }
}

struct ChatGroupInteractor {
	let appState: Store<AppState>
}

extension ChatGroupInteractor: IChatGroupInteractor {
	var worker: IChatGroupWorker {
		let remoteStore = ChatGroupRemoteStore()
		let inMemoryStore = ChatGroupInMemoryStore()
		return ChatGroupWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}

struct StubChatGroupInteractor: IChatGroupInteractor {
	var worker: IChatGroupWorker {
		let remoteStore = ChatGroupRemoteStore()
		let inMemoryStore = ChatGroupInMemoryStore()
		return ChatGroupWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
