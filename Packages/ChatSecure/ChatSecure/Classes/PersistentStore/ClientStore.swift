//
//  ClientStore.swift
//  ChatSecure
//
//  Created by NamNH on 24/02/2022.
//

import Common
import SignalProtocolObjC

enum ClientError: LocalizedError {
	case encoding(message: String)
	case encrypt(message: String)
	case decrypt(message: String)
	case initKeyPair(message: String)
}

public struct ClientStore {
	private var persistentStoreService: IPersistentStoreService!
	
	public init(persistentStoreService: IPersistentStoreService) {
		self.persistentStoreService = persistentStoreService
	}
	
	func getUniqueDeviceId() -> String {
		guard let deviceId = persistentStoreService.get(key: "DEVICE_ID") as? String else {
			let newDeviceId = UUID().uuidString
			Debug.DLog("Generate new unique device id: \(newDeviceId)")
			persistentStoreService.set(value: newDeviceId, key: "DEVICE_ID")
			return newDeviceId
		}
		return deviceId
	}
}
