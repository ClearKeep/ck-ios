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
			let caller = clientSignal.peerRegisterClientKey(request, callOptions: callOptions)
			
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
	
	public func peerGetClientKey(_ request: Signal_PeerGetClientKeyRequest) async -> Result<Signal_PeerGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.peerGetClientKey(request, callOptions: callOptions)
			
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
	
	public func workspacePeerGetClientKey(_ request: Signal_PeerGetClientKeyRequest) async -> Result<Signal_PeerGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.workspacePeerGetClientKey(request, callOptions: callOptions)
			
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
	
	public func clientUpdatePeerKey(_ request: Signal_PeerRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.clientUpdatePeerKey(request, callOptions: callOptions)
			
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
	
	public func groupRegisterClientKey(_ request: Signal_GroupRegisterClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.groupRegisterClientKey(request, callOptions: callOptions)
			
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
	
	public func groupUpdateClientKey(_ request: Signal_GroupUpdateClientKeyRequest) async -> Result<Signal_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.groupUpdateClientKey(request, callOptions: callOptions)
			
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
	
	public func groupGetClientKey(_ request: Signal_GroupGetClientKeyRequest) async -> Result<Signal_GroupGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.groupGetClientKey(request, callOptions: callOptions)
			
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
	
	public func groupGetAllClientKey(_ request: Signal_GroupGetAllClientKeyRequest) async -> Result<Signal_GroupGetAllClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.groupGetAllClientKey(request, callOptions: callOptions)
			
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
	
	public func workspaceGroupGetClientKey(_ request: Signal_WorkspaceGroupGetClientKeyRequest) async -> Result<Signal_WorkspaceGroupGetClientKeyResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientSignal.workspaceGroupGetClientKey(request, callOptions: callOptions)
			
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
