//
//  MessageAPIService.swift
//  Networking
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Combine

public protocol IMessageAPIService {
	func getMessage(_ request: Message_GetMessagesInGroupRequest) async -> (Result<Message_GetMessagesInGroupResponse, Error>)
	func getMessageWorkspace(_ request: Message_WorkspaceGetMessagesInGroupRequest) async -> (Result<Message_GetMessagesInGroupResponse, Error>)
	func subscribe(_ request: Message_SubscribeRequest) async -> (Result<Message_BaseResponse, Error>)
	func unSubscribe(_ request: Message_UnSubscribeRequest) async -> (Result<Message_BaseResponse, Error>)
	func listen(_ request: Message_ListenRequest) async -> (String, Message_MessageObjectResponse)
	func sendMessage(_ request: Message_PublishRequest) async -> (Result<Message_MessageObjectResponse, Error>)
	func sendMessageWorkspace(_ request: Message_WorkspacePublishRequest) async -> (Result<Message_MessageObjectResponse, Error>)
}

extension APIService: IMessageAPIService {
	public func getMessage(_ request: Message_GetMessagesInGroupRequest) async -> (Result<Message_GetMessagesInGroupResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let status = clientMessage.get_messages_in_group(request).status
			let response = clientMessage.get_messages_in_group(request).response
			
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
	
	public func getMessageWorkspace(_ request: Message_WorkspaceGetMessagesInGroupRequest) async -> (Result<Message_GetMessagesInGroupResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let status = clientMessage.workspace_get_messages_in_group(request).status
			let response = clientMessage.workspace_get_messages_in_group(request).response
			
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
	
	public func subscribe(_ request: Message_SubscribeRequest) async -> (Result<Message_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let status = clientMessage.subscribe(request).status
			let response = clientMessage.subscribe(request).response
			
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
	
	public func unSubscribe(_ request: Message_UnSubscribeRequest) async -> (Result<Message_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let status = clientMessage.unSubscribe(request).status
			let response = clientMessage.unSubscribe(request).response
			
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
	
	public func listen(_ request: Message_ListenRequest) async -> (String, Message_MessageObjectResponse) {
		return await withCheckedContinuation({ continuation in
			do {
				try clientMessage.listen(request) { publication in
					guard let data = try? publication.serializedData(),
						  let response = try? Message_MessageObjectResponse(serializedData: data) else { return }
					continuation.resume(returning: (publication.fromClientID, response))
				}.status.wait()
			} catch {
			}
		})
	}
	
	public func sendMessage(_ request: Message_PublishRequest) async -> (Result<Message_MessageObjectResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let status = clientMessage.publish(request).status
			let response = clientMessage.publish(request).response
			
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
	
	public func sendMessageWorkspace(_ request: Message_WorkspacePublishRequest) async -> (Result<Message_MessageObjectResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let status = clientMessage.workspace_publish(request).status
			let response = clientMessage.workspace_publish(request).response
			
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