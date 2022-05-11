//
//  VideoCallAPIService.swift
//  Networking
//
//  Created by NamNH on 18/04/2022.
//

import Foundation

public protocol IVideoCallAPIService {
	func videoCall(_ request: VideoCall_VideoCallRequest) async -> Result<VideoCall_ServerResponse, Error>
	func updateCall(_ request: VideoCall_UpdateCallRequest) async -> Result<VideoCall_BaseResponse, Error>
	func workspaceVideoCall(_ request: VideoCall_WorkspaceVideoCallRequest) async -> Result<VideoCall_ServerResponse, Error>
	func workspaceUpdateCall(_ request: VideoCall_WorkspaceUpdateCallRequest) async -> Result<VideoCall_BaseResponse, Error>
}

extension APIService: IVideoCallAPIService {
	public func videoCall(_ request: VideoCall_VideoCallRequest) async -> Result<VideoCall_ServerResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientVideoCall.video_call(request, callOptions: callOptions)
			
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
	
	public func updateCall(_ request: VideoCall_UpdateCallRequest) async -> Result<VideoCall_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientVideoCall.update_call(request, callOptions: callOptions)
			
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
	
	public func workspaceVideoCall(_ request: VideoCall_WorkspaceVideoCallRequest) async -> Result<VideoCall_ServerResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientVideoCall.workspace_video_call(request, callOptions: callOptions)
			
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
	
	public func workspaceUpdateCall(_ request: VideoCall_WorkspaceUpdateCallRequest) async -> Result<VideoCall_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientVideoCall.workspace_update_call(request, callOptions: callOptions)
			
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
