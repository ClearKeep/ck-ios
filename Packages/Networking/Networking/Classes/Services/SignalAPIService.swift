//
//  SignalService.swift
//  
//
//  Created by NamNH on 22/02/2022.
//

import Foundation

public protocol ISignalAPIService {
	/// peer
	func peerRegisterClientKey(_ request: Signal_PeerRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error>
	func peerGetClientKey(_ request: Signal_PeerGetClientKeyRequest) async -> Result<Signal_PeerGetClientKeyResponse, Error>
	func workspacePeerGetClientKey(_ request: Signal_PeerGetClientKeyRequest) async -> Result<Signal_PeerGetClientKeyResponse, Error>
	func clientUpdatePeerKey(_ request: Signal_PeerRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error>

	/// group
	func groupRegisterClientKey(_ request: Signal_GroupRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error>
	func groupUpdateClientKey(_ request: Signal_GroupUpdateClientKeyRequest) async -> Result<Signal_BaseResponse, Error>
	func groupGetClientKey(_ request: Signal_GroupGetClientKeyRequest) async -> Result<Signal_GroupGetClientKeyResponse, Error>
	func groupGetAllClientKey(_ request: Signal_GroupGetAllClientKeyRequest) async -> Result<Signal_GroupGetAllClientKeyResponse, Error>

	/// workspace
	func workspaceGroupGetClientKey(_ request: Signal_WorkspaceGroupGetClientKeyRequest) async -> Result<Signal_WorkspaceGroupGetClientKeyResponse, Error>
}

extension APIService: ISignalAPIService {
    public func peerRegisterClientKey(_ request: Signal_PeerRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.peerRegisterClientKey(request).status
			let response = clientSignal.peerRegisterClientKey(request).response
			
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
	
    public func peerGetClientKey(_ request: Signal_PeerGetClientKeyRequest) async -> Result<Signal_PeerGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.peerGetClientKey(request).status
			let response = clientSignal.peerGetClientKey(request).response
			
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
	
    public func workspacePeerGetClientKey(_ request: Signal_PeerGetClientKeyRequest) async -> Result<Signal_PeerGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.workspacePeerGetClientKey(request).status
			let response = clientSignal.workspacePeerGetClientKey(request).response
			
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
	
    public func clientUpdatePeerKey(_ request: Signal_PeerRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.clientUpdatePeerKey(request).status
			let response = clientSignal.clientUpdatePeerKey(request).response
			
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
	
    public func groupRegisterClientKey(_ request: Signal_GroupRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.groupRegisterClientKey(request).status
			let response = clientSignal.groupRegisterClientKey(request).response
			
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
	
    public func groupUpdateClientKey(_ request: Signal_GroupUpdateClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.groupUpdateClientKey(request).status
			let response = clientSignal.groupUpdateClientKey(request).response
			
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
	
    public func groupGetClientKey(_ request: Signal_GroupGetClientKeyRequest) async -> Result<Signal_GroupGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.groupGetClientKey(request).status
			let response = clientSignal.groupGetClientKey(request).response
			
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
	
    public func groupGetAllClientKey(_ request: Signal_GroupGetAllClientKeyRequest) async -> Result<Signal_GroupGetAllClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.groupGetAllClientKey(request).status
			let response = clientSignal.groupGetAllClientKey(request).response
			
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
	
    public func workspaceGroupGetClientKey(_ request: Signal_WorkspaceGroupGetClientKeyRequest) async -> Result<Signal_WorkspaceGroupGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientSignal.workspaceGroupGetClientKey(request).status
			let response = clientSignal.workspaceGroupGetClientKey(request).response
			
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
