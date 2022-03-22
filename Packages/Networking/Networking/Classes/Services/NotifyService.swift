//
//  NotifyService.swift
//  
//
//  Created by NamNH on 22/02/2022.
//

import Foundation

protocol INotifyService {
	func listen(deviceId: String) async -> Notification_NotifyObjectResponse
	func subscribe(deviceId: String) async -> Result<Notification_BaseResponse, Error>
	func unSubscribe(deviceId: String) async -> Result<Notification_BaseResponse, Error>
}

struct NotifyService {
	let clientNotify: Notification_NotifyClientProtocol!
	
	init(_ clientNotify: Notification_NotifyClientProtocol) {
		self.clientNotify = clientNotify
	}
}

extension NotifyService: INotifyService {
	func listen(deviceId: String) async -> Notification_NotifyObjectResponse {
		let request: Notification_ListenRequest = .with {
			$0.deviceID = deviceId
		}
		
		return await withCheckedContinuation({ continuation in
			do {
				try clientNotify.listen(request) { publication in
					guard let data = try? publication.serializedData(),
						  let response = try? Notification_NotifyObjectResponse(serializedData: data) else { return }
					continuation.resume(returning: response)
				}.status.wait()
			} catch {
			}
		})
	}
	
	func subscribe(deviceId: String) async -> Result<Notification_BaseResponse, Error> {
		let request: Notification_SubscribeRequest = .with {
			$0.deviceID = deviceId
		}
		return await withCheckedContinuation({ continuation in
			clientNotify.subscribe(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func unSubscribe(deviceId: String) async -> Result<Notification_BaseResponse, Error> {
		let request: Notification_UnSubscribeRequest = .with {
			$0.deviceID = deviceId
		}
		return await withCheckedContinuation({ continuation in
			clientNotify.un_subscribe(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
}
