//
//  AdvancedSeverInteractor.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Common
import ChatSecure
import Model
import CommonUI

protocol IAdvancedSeverInteractor {
	var worker: IAdvancedSeverWorker { get }
	func workspaceInfo(workspaceDomain: String) async -> Loadable<Bool>
}

struct AdvancedSeverInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let workspaceService: IWorkspaceService
}

extension AdvancedSeverInteractor: IAdvancedSeverInteractor {
	var worker: IAdvancedSeverWorker {
		let remoteStore = AdvancedSeverRemoteStore(workspaceService: workspaceService)
		let inMemoryStore = AdvancedSeverInMemoryStore()
		return AdvancedSeverWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func workspaceInfo(workspaceDomain: String) async -> Loadable<Bool> {
		let result = await worker.workspaceInfo(workspaceDomain: workspaceDomain)
		
		switch result {
		case .success(let data):
			return .loaded(data)
		case .failure(let error):
			return .failed(error)
		}
	}
}
struct StubAdvancedSeverInteractor: IAdvancedSeverInteractor {
	let channelStorage: IChannelStorage
	let workspaceService: IWorkspaceService
	
	var worker: IAdvancedSeverWorker {
		let remoteStore = AdvancedSeverRemoteStore(workspaceService: workspaceService)
		let inMemoryStore = AdvancedSeverInMemoryStore()
		return AdvancedSeverWorker(channelStorage: channelStorage, remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}
	
	func workspaceInfo(workspaceDomain: String) async -> Loadable<Bool> {
		return .notRequested
	}
}
