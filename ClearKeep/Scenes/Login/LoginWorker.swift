//
//  LoginWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 07/03/2022.
//

import Foundation

protocol ILoginWorker {
	var remoteStore: ILoginRemoteStore { get }
	var inMemoryStore: ILoginInMemoryStore { get }
}

struct LoginWorker {
	let remoteStore: ILoginRemoteStore
	let inMemoryStore: ILoginInMemoryStore
	
	init(remoteStore: ILoginRemoteStore,
		 inMemoryStore: ILoginInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension LoginWorker: ILoginWorker {
}
