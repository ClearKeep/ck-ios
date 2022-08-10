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
	private var securedStoreService: ISecuredStoreService
	public init(persistentStoreService: IPersistentStoreService, securedStoreService: ISecuredStoreService) {
		self.persistentStoreService = persistentStoreService
		self.securedStoreService = securedStoreService
	}
	
	func getUniqueDeviceId() -> String {
		guard let deviceId = securedStoreService.get(key: "DEVICE_ID") as? String else {
			let newDeviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
			Debug.DLog("Generate new unique device id: \(newDeviceId)")
			securedStoreService.set(value: newDeviceId, key: "DEVICE_ID")
			return newDeviceId
		}
		return deviceId
	}
}
