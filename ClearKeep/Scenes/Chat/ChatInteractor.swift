//
//  ChatInteractor.swift
//  ClearKeep
//
//  Created by Quang Pham on 22/04/2022.
//

import Common

protocol IChatInteractor {
	var worker: IChatWorker { get }
}

struct ChatInteractor {
	let appState: Store<AppState>
}

extension ChatInteractor: IChatInteractor {
	var worker: IChatWorker {
		let remoteStore = ChatRemoteStore()
		let inMemoryStore = ChatInMemoryStore()
		return ChatWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
