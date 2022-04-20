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
	func subscribe(_ request: Notification_SubscribeRequest) async -> Result<Notification_BaseResponse, Error>
	func unSubscribe(_ request: Notification_UnSubscribeRequest) async -> Result<Notification_BaseResponse, Error>
	func listen(_ request: Notification_ListenRequest) async -> Result<Notification_NotifyObjectResponse, Error>
}

extension APIService: INotifyAPIService {
	public func readNotify(_ request: Notification_ReadNotifyRequest) async -> Result<Notification_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientNotify.read_notify(request).status
			let response = clientNotify.read_notify(request).response
			
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
	
	public func getUnreadNotifies(_ request: Notification_Empty) async -> Result<Notification_GetNotifiesResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientNotify.get_unread_notifies(request).status
			let response = clientNotify.get_unread_notifies(request).response
			
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
	
	public func subscribe(_ request: Notification_SubscribeRequest) async -> Result<Notification_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientNotify.subscribe(request).status
			let response = clientNotify.subscribe(request).response
			
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
	
	public func unSubscribe(_ request: Notification_UnSubscribeRequest) async -> Result<Notification_BaseResponse, Error> {
		return await withCheckedContinuation({ continuation in
			let status = clientNotify.un_subscribe(request).status
			let response = clientNotify.un_subscribe(request).response
			
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
	
	public func listen(_ request: Notification_ListenRequest) async -> Result<Notification_NotifyObjectResponse, Error> {
		return await withCheckedContinuation({ continuation in
			do {
				try clientNotify.listen(request) { publication in
					guard let data = try? publication.serializedData(),
						  let response = try? Notification_NotifyObjectResponse(serializedData: data) else {
						continuation.resume(returning: .failure(ServerError.unknown))
						return }
					continuation.resume(returning: .success(response))
				}.status.wait()
			} catch {
				continuation.resume(returning: .failure(error))
			}
		})
	}
}
