//
//  ServerInfoAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

protocol IServerInfoAPIService {
	func updateNts(_ request: ServerInfo_UpdateNTSReq) async -> Result<ServerInfo_BaseResponse, Error>
	func totalThread(_ request: ServerInfo_Empty) async -> Result<ServerInfo_GetThreadResponse, Error>
}

extension APIService: IServerInfoAPIService {
	func updateNts(_ request: ServerInfo_UpdateNTSReq) async -> Result<ServerInfo_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let response = clientServerInfo.update_nts(request).response
			let status = clientServerInfo.update_nts(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
	
	func totalThread(_ request: ServerInfo_Empty) async -> Result<ServerInfo_GetThreadResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let response = clientServerInfo.total_thread(request).response
			let status = clientServerInfo.total_thread(request).status
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
