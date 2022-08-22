//
//  INotifyAPIService.swift
//  
//
//  Created by NamNH on 22/02/2022.
//

import Foundation

public protocol INotifyAPIService {
	func readNotify(_ request: Notification_ReadNotifyRequest) async -> Result<Notification_BaseResponse, Error>
	func getUnreadNotifies(_ request: Notification_Empty) async -> Result<Notification_GetNotifiesResponse, Error>
	func subscribe(_ request: Notification_SubscribeRequest, completion: @escaping (() -> Void))
	func unSubscribe(_ request: Notification_UnSubscribeRequest, completion: @escaping (() -> Void))
	func listen(_ request: Notification_ListenRequest, completion: @escaping (Result<Notification_NotifyObjectResponse, Error>) -> Void)
}

extension APIService: INotifyAPIService {
	public func readNotify(_ request: Notification_ReadNotifyRequest) async -> Result<Notification_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientNotify.read_notify(request, callOptions: callOptions)
			
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
	
	public func getUnreadNotifies(_ request: Notification_Empty) async -> Result<Notification_GetNotifiesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let caller = clientNotify.get_unread_notifies(request, callOptions: callOptions)
			
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
	
	public func subscribe(_ request: Notification_SubscribeRequest, completion: @escaping (() -> Void)) {
		let caller = clientNotify.subscribe(request, callOptions: callOptions).response
		
		caller.whenComplete { (_) in
			completion()
		}
		caller.whenFailure { error in
			print("\(error) subscribe signal failed")
		}
	}
	
	public func unSubscribe(_ request: Notification_UnSubscribeRequest, completion: @escaping (() -> Void)) {
		let caller = clientNotify.un_subscribe(request, callOptions: callOptions).response
		
		caller.whenComplete { (_) in
			completion()
		}
		caller.whenFailure { error in
			print("\(error) subscribe signal failed")
		}
	}
	
	public func listen(_ request: Notification_ListenRequest, completion: @escaping (Result<Notification_NotifyObjectResponse, Error>) -> Void) {
		DispatchQueue.global(qos: .background).async {
			do {
				let caller = self.clientNotify.listen(request, callOptions: self.callOptions) { publication in
					guard let data = try? publication.serializedData(),
						  let response = try? Notification_NotifyObjectResponse(serializedData: data) else {
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
}
