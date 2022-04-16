//
//  ChatMessageInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 30/03/2022.
//

import Common

protocol IChatMessageInteractor {
	var worker: IChatMessageWorker { get }
}

struct ChatMessageInteractor {
	let appState: Store<AppState>
}

extension ChatMessageInteractor: IChatMessageInteractor {
	var worker: IChatMessageWorker {
		let remoteStore = ChatMessageRemoteStore()
		let inMemoryStore = ChatMessageInMemoryStore()
		return ChatMessageWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
