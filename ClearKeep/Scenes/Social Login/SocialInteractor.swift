//
//  SocialInteractor.swift
//  ClearKeep
//
//  Created by đông on 08/03/2022.
//

import Common

protocol ISocialInteractor {
	var worker: ISocialWorker { get }
}

struct SocialInteractor {
	let appState: Store<AppState>
}

extension SocialInteractor: ISocialInteractor {
	var worker: ISocialWorker {
		let remoteStore = SocialRemoteStore()
		let inMemoryStore = SocialInMemoryStore()
		return SocialWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}

struct StubSocialInteractor: ISocialInteractor {
	var worker: ISocialWorker {
		let remoteStore = SocialRemoteStore()
		let inMemoryStore = SocialInMemoryStore()
		return SocialWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
