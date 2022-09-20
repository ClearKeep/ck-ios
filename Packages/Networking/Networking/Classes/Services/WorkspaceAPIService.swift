//
//  WorkspaceAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

public protocol IWorkspaceAPIService {
	func workspaceInfo(_ request: Workspace_WorkspaceInfoRequest) async -> Result<Workspace_WorkspaceInfoResponse, Error>
	func leaveWorkspace(_ request: Workspace_LeaveWorkspaceRequest) async -> Result<Workspace_BaseResponse, Error>
}

extension APIService: IWorkspaceAPIService {
	public func workspaceInfo(_ request: Workspace_WorkspaceInfoRequest) async -> Result<Workspace_WorkspaceInfoResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientWorkspace.workspace_info(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func leaveWorkspace(_ request: Workspace_LeaveWorkspaceRequest) async -> Result<Workspace_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientWorkspace.leave_workspace(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
}
