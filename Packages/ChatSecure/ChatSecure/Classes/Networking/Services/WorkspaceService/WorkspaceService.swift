//
//  WorkspaceService.swift
//  _NIODataStructures
//
//  Created by MinhDev on 03/08/2022.
//

import Foundation
import Networking

public protocol IWorkspaceService {
	func workspaceInfo(workspaceDomain: String) async -> Result<Workspace_WorkspaceInfoResponse, Error>
}

public class WorkspaceService {
	public init() {
	}
}

extension WorkspaceService: IWorkspaceService {
	public func workspaceInfo(workspaceDomain: String) async -> Result<Workspace_WorkspaceInfoResponse, Error> {
		var request = Workspace_WorkspaceInfoRequest()
		request.workspaceDomain = workspaceDomain
		let domain = channelStorage.currentDomain
		return await channelStorage.getChannel(domain: domain).workspaceInfo(request)
	}
}
