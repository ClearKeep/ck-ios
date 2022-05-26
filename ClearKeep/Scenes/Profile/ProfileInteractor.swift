//
//  ProfileInteractor.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import Common

protocol IProfileInteractor {
	var worker: IProfileWorker { get }
}

struct ProfileInteractor {
	let appState: Store<AppState>
}

extension ProfileInteractor: IProfileInteractor {
	var worker: IProfileWorker {
		let remoteStore = ProfileRemoteStore()
		let inMemoryStore = ProfileInMemoryStore()
		return ProfileWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
