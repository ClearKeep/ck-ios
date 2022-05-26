//
//  ProfileWorker.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import Foundation

protocol IProfileWorker {
	var remoteStore: IProfileRemoteStore { get }
	var inMemoryStore: IProfileInMemoryStore { get }
}

struct ProfileWorker {
	let remoteStore: IProfileRemoteStore
	let inMemoryStore: IProfileInMemoryStore
	
	init(remoteStore: IProfileRemoteStore,
		 inMemoryStore: IProfileInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ProfileWorker: IProfileWorker {
}
