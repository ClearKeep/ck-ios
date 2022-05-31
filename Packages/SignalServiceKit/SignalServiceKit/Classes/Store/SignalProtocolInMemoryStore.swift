//
//  SignalProtocolInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import Foundation
import LibSignalClient

public protocol ISignalProtocolInMemoryStore {
	func saveUserPreKey(preKey: PreKeyRecord, id: UInt32) throws
	func saveUserSignedPreKey(signedPreKey: SignedPreKeyRecord, id: UInt32) throws
	func saveUserIdentity(identity: SignalIdentityKey) throws
}

public final class SignalProtocolInMemoryStore: ISignalProtocolInMemoryStore {
	// MARK: - Variables
	let identityStore: IIdentityKeyInMemoryStore
	let sessionStore: SessionStore
	let preKeyStore: PreKeyStore
	let signedPreKeyStore: SignedPreKeyStore
	
	let storage: YapDatabaseManager

	// MARK: - Init
	public init(storage: YapDatabaseManager) {
		self.storage = storage
		sessionStore = SessionInMemoryStore()
		identityStore = IdentityKeyInMemoryStore(storage: storage)
		preKeyStore = PreKeyInMemoryStore(storage: storage)
		signedPreKeyStore = SignedPreKeyInMemoryStore(storage: storage)
	}
	
	public func saveUserPreKey(preKey: PreKeyRecord, id: UInt32) throws {
		try preKeyStore.storePreKey(preKey, id: id, context: NullContext())
	}
	
	public func saveUserSignedPreKey(signedPreKey: SignedPreKeyRecord, id: UInt32) throws {
		try signedPreKeyStore.storeSignedPreKey(signedPreKey, id: id, context: NullContext())
	}
	
	public func saveUserIdentity(identity: SignalIdentityKey) throws {
		try identityStore.saveUserIdentity(identity: identity)
	}
}
