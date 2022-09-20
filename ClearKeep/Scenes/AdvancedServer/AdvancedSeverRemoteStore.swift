//
//  AdvancedSeverRemoteStore.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import Foundation
import Combine
import ChatSecure
import Model

protocol IAdvancedSeverRemoteStore {
	func workspaceInfo(workspaceDomain: String) async -> Result<Bool, Error>
}

struct AdvancedSeverRemoteStore {
	let workspaceService: IWorkspaceService
}

extension AdvancedSeverRemoteStore: IAdvancedSeverRemoteStore {
	func workspaceInfo(workspaceDomain: String) async -> Result<Bool, Error> {
		let result = await workspaceService.workspaceInfo(workspaceDomain: workspaceDomain)
		switch result {
		case .success:
			return .success(true)
		case .failure(let error):
			return .failure(error)
		}
	}
}
