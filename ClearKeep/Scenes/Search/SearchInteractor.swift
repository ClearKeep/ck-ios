//
//  SearchInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common

protocol ISearchInteractor {
	var worker: ISearchWorker { get }
}

struct SearchInteractor {
	let appState: Store<AppState>
}

extension SearchInteractor: ISearchInteractor {
	var worker: ISearchWorker {
		let remoteStore = SearchRemoteStore()
		let inMemoryStore = SearchInMemoryStore()
		return SearchWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
}
