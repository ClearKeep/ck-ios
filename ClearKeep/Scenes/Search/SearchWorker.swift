//
//  SearchWorker.swift
//  ClearKeep
//
//  Created by MinhDev on 05/04/2022.
//

import Foundation

protocol ISearchWorker {
	var remoteStore: ISearchRemoteStore { get }
	var inMemoryStore: ISearchInMemoryStore { get }
}

struct SearchWorker {
	let remoteStore: ISearchRemoteStore
	let inMemoryStore: ISearchInMemoryStore
	
	init(remoteStore: ISearchRemoteStore,
		 inMemoryStore: ISearchInMemoryStore) {
		self.remoteStore = remoteStore
		self.inMemoryStore = inMemoryStore
	}
}

extension SearchWorker: ISearchWorker {
}
