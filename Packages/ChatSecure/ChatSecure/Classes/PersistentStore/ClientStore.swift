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

struct ClientStore {
	private var persistentStoreService: IPersistentStoreService!
//	let keyHelper: SignalKeyHelper?
//	let preKey: SignalPreKey?
//	let signedPreKey: SignalSignedPreKey?
//	let address: SignalAddress
//
//	init(clientID: String, deviceID: Int32) {
//		address = SignalAddress(name: clientID, deviceId: deviceID)
//
//		let inMemoryStore: SignalInMemoryStore = SignalInMemoryStore()
//		let storage = SignalStorage(signalStore: inMemoryStore)
//		let context = SignalContext(storage: storage)
//		keyHelper = SignalKeyHelper(context: context ?? SignalContext())
//
//		inMemoryStore.identityKeyPair = keyHelper?.generateIdentityKeyPair()
//		inMemoryStore.localRegistrationId = UInt32(keyHelper?.generateRegistrationId() ?? 0)
//
//		let preKeys = keyHelper?.generatePreKeys(withStartingPreKeyId: 0, count: 2)
//		preKey = preKeys?.first
//		signedPreKey = keyHelper?.generateSignedPreKey(withIdentity: inMemoryStore.getIdentityKeyPair(), signedPreKeyId: 1)
//
//		inMemoryStore.storePreKey(preKey?.serializedData() ?? Data(), preKeyId: preKey?.preKeyId ?? 0)
//		inMemoryStore.storeSignedPreKey(signedPreKey?.serializedData() ?? Data(), signedPreKeyId: signedPreKey?.preKeyId ?? 0)
//	}
	func getUniqueDeviceId() -> String {
		guard let deviceId = persistentStoreService.get(key: "DEVICE_ID") as? String else {
			let newDeviceId = UUID().uuidString
			print("generate new device id: \(newDeviceId)")
			persistentStoreService.set(value: newDeviceId, key: "DEVICE_ID")
			return newDeviceId
		}
		return deviceId
	}
}
