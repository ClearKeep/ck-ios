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
	let sampleAPIService: IAPIService
}

extension SocialInteractor: ISocialInteractor {
	var worker: ISocialWorker {
		let remoteStore = SocialRemoteStore(sampleAPIService: sampleAPIService)
		let inMemoryStore = SocialInMemoryStore()
		return SocialWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}

struct StubSocialInteractor: ISocialInteractor {
	let sampleAPIService: IAPIService

	var worker: ISocialWorker {
		let remoteStore = SocialRemoteStore(sampleAPIService: sampleAPIService)
		let inMemoryStore = SocialInMemoryStore()
		return SocialWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
