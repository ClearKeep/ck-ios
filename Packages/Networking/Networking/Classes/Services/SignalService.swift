//
//  SignalService.swift
//  
//
//  Created by NamNH on 22/02/2022.
//

import Foundation

protocol ISignalService {
	func listen(deviceId: String) async -> (String, Message_MessageObjectResponse)
	func subscribe(deviceId: String) async -> Result<Message_BaseResponse, Error>
	func unSubscribe(deviceId: String) async -> Result<Message_BaseResponse, Error>
}

struct SignalService {
	let clientSignal: Message_MessageClientProtocol!
	
	init(_ clientSignal: Message_MessageClientProtocol) {
		self.clientSignal = clientSignal
	}
}

extension SignalService: ISignalService {
	func listen(deviceId: String) async -> (String, Message_MessageObjectResponse) {
		let request: Message_ListenRequest = .with {
			$0.deviceID = deviceId
		}
		
		return await withCheckedContinuation({ continuation in
			do {
				try clientSignal.listen(request) { publication in
					guard let data = try? publication.serializedData(),
						  let response = try? Message_MessageObjectResponse(serializedData: data) else { return }
					continuation.resume(returning: (publication.fromClientID, response))
				}.status.wait()
			} catch {
			}
		})
	}
	
	func subscribe(deviceId: String) async -> Result<Message_BaseResponse, Error> {
		let request: Message_SubscribeRequest = .with {
			$0.deviceID = deviceId
		}
		return await withCheckedContinuation({ continuation in
			clientSignal.subscribe(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
	
	func unSubscribe(deviceId: String) async -> Result<Message_BaseResponse, Error> {
		let request: Message_UnSubscribeRequest = .with {
			$0.deviceID = deviceId
		}
		return await withCheckedContinuation({ continuation in
			clientSignal.unSubscribe(request).response.whenComplete { result in
				continuation.resume(returning: result)
			}
		})
	}
}
