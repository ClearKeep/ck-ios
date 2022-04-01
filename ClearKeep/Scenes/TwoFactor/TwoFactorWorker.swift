//
//  TwoFactorWorker.swift
//  ClearKeep
//
//  Created by đông on 01/04/2022.
//

import Foundation

protocol ITwoFactorWorker {
	var remoteStore: ITwoFactorRemoteStore { get }
	var inMemoryStore: ITwoFactorInMemoryStore { get }
}

struct TwoFactorWorker {
	let remoteStore: ITwoFactorRemoteStore
	let inMemoryStore: ITwoFactorInMemoryStore

	init(remoteStore: ITwoFactorRemoteStore,
		 inMemoryStore: ITwoFactorInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension TwoFactorWorker: ITwoFactorWorker {
}
