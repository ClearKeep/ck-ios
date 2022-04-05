//
//  CallWorker.swift
//  ClearKeep
//
//  Created by đông on 05/04/2022.
//

import Foundation

protocol ICallWorker {
	var remoteStore: ICallRemoteStore { get }
	var inMemoryStore: ICallInMemoryStore { get }
}

struct CallWorker {
	let remoteStore: ICallRemoteStore
	let inMemoryStore: ICallInMemoryStore
	
	init(remoteStore: ICallRemoteStore,
		 inMemoryStore: ICallInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension CallWorker: ICallWorker {
}
