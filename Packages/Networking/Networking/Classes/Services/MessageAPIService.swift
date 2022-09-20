//
//  MessageAPIService.swift
//  Networking
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Combine

public protocol IMessageAPIService {
	func getMessage(_ request: Message_GetMessagesInGroupRequest) async -> Result<Message_GetMessagesInGroupResponse, Error>
	func getMessageWorkspace(_ request: Message_WorkspaceGetMessagesInGroupRequest) async -> Result<Message_GetMessagesInGroupResponse, Error>
	func subscribe(_ request: Message_SubscribeRequest, completion:@escaping (() -> Void))
	func unSubscribe(_ request: Message_UnSubscribeRequest, completion: @escaping (() -> Void))
	func listen(_ request: Message_ListenRequest, completion: @escaping (Result<Message_MessageObjectResponse, Error>) -> Void)
	func sendMessage(_ request: Message_PublishRequest) async -> Result<Message_MessageObjectResponse, Error>
	func sendMessageWorkspace(_ request: Message_WorkspacePublishRequest) async -> Result<Message_MessageObjectResponse, Error>
}

extension APIService: IMessageAPIService {
	public func getMessage(_ request: Message_GetMessagesInGroupRequest) async -> Result<Message_GetMessagesInGroupResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientMessage.get_messages_in_group(request, callOptions: callOptions)
			
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
	
	public func getMessageWorkspace(_ request: Message_WorkspaceGetMessagesInGroupRequest) async -> Result<Message_GetMessagesInGroupResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientMessage.workspace_get_messages_in_group(request, callOptions: callOptions)
			
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
	
	public func subscribe(_ request: Message_SubscribeRequest, completion: @escaping (() -> Void)) {
		let caller = clientMessage.subscribe(request, callOptions: callOptions).response
		
		caller.whenComplete { (_) in
			completion()
		}
		caller.whenFailure { error in
			print("\(error) subscribe signal failed")
		}
	}
	
	public func unSubscribe(_ request: Message_UnSubscribeRequest, completion: @escaping (() -> Void)) {
		let caller = clientMessage.unSubscribe(request, callOptions: callOptions).response
		
		caller.whenComplete { (_) in
			completion()
		}
		caller.whenFailure { error in
			print("\(error) subscribe signal failed")
		}
	}
	
	public func listen(_ request: Message_ListenRequest, completion: @escaping (Result<Message_MessageObjectResponse, Error>) -> Void) {
		DispatchQueue.global(qos: .background).async {
			do {
				let caller = self.clientMessage.listen(request, callOptions: self.callOptions) { publication in
					guard let data = try? publication.serializedData(),
						  let response = try? Message_MessageObjectResponse(serializedData: data) else {
						completion(.failure(ServerError.unknown))
						return
					}
					completion(.success(response))
				}
				let status = try caller.status.wait()
				print(status)
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	public func sendMessage(_ request: Message_PublishRequest) async -> Result<Message_MessageObjectResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientMessage.publish(request, callOptions: callOptions)
			
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
	
	public func sendMessageWorkspace(_ request: Message_WorkspacePublishRequest) async -> Result<Message_MessageObjectResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientMessage.workspace_publish(request, callOptions: callOptions)
			
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
