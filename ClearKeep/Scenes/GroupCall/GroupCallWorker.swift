//
//  GroupCallWorker.swift
//  ClearKeep
//
//  Created by đông on 07/04/2022.
//

import Foundation

protocol IGroupCallWorker {
	var remoteStore: IGroupCallRemoteStore { get }
	var inMemoryStore: IGroupCallInMemoryStore { get }
}

struct GroupCallWorker {
	let remoteStore: IGroupCallRemoteStore
	let inMemoryStore: IGroupCallInMemoryStore
	
	init(remoteStore: IGroupCallRemoteStore,
		 inMemoryStore: IGroupCallInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension GroupCallWorker: IGroupCallWorker {
}
