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

}

struct CallInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage

}

extension CallInteractor: ICallInteractor {
	var worker: ICallWorker {
		let remoteStore = CallRemoteStore()
		let inMemoryStore = CallInMemoryStore()
		return CallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

}

struct StubCallInteractor: ICallInteractor {
		
	var worker: ICallWorker {
		let remoteStore = CallRemoteStore()
		let inMemoryStore = CallInMemoryStore()
		return CallWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
