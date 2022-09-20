//
//  ServerInfoAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

public protocol IServerInfoAPIService {
	func updateNts(_ request: ServerInfo_UpdateNTSReq) async -> Result<ServerInfo_BaseResponse, Error>
	func totalThread(_ request: ServerInfo_Empty) async -> Result<ServerInfo_GetThreadResponse, Error>
}

extension APIService: IServerInfoAPIService {
	public func updateNts(_ request: ServerInfo_UpdateNTSReq) async -> Result<ServerInfo_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientServerInfo.update_nts(request, callOptions: callOptions)
			
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
	
	public func totalThread(_ request: ServerInfo_Empty) async -> Result<ServerInfo_GetThreadResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientServerInfo.total_thread(request, callOptions: callOptions)
			
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
