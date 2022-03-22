//
//  ChangePasswordWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation

protocol IChangePasswordWorker {
	var remoteStore: IChangePasswordRemoteStore { get }
	var inMemoryStore: IChangePasswordInMemoryStore { get }
}

struct ChangePasswordWorker {
	let remoteStore: IChangePasswordRemoteStore
	let inMemoryStore: IChangePasswordInMemoryStore
	
	init(remoteStore: IChangePasswordRemoteStore,
		 inMemoryStore: IChangePasswordInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension ChangePasswordWorker: IChangePasswordWorker {
}
