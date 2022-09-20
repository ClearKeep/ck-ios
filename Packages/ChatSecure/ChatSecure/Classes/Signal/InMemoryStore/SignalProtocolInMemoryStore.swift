//
//  SignalProtocolInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import SignalServiceKit
import LibSignalClient

public protocol ISignalProtocolInMemoryStore {
	var identityStore: IIdentityKeyInMemoryStore { get }
	var sessionStore: ISessionInMemoryStore { get }
	var preKeyStore: IPreKeyInMemoryStore { get }
	var signedPreKeyStore: SignedPreKeyStore { get }
	func saveUserPreKey(preKey: PreKeyRecord, id: UInt32) throws
	func saveUserSignedPreKey(signedPreKey: SignedPreKeyRecord, id: UInt32) throws
	func saveUserIdentity(identity: SignalIdentityKey) throws
	func deleteKeys(domain: String, clientId: String)
}

public final class SignalProtocolInMemoryStore: ISignalProtocolInMemoryStore {
	// MARK: - Variables
	public var identityStore: IIdentityKeyInMemoryStore
	public var sessionStore: ISessionInMemoryStore
	public var preKeyStore: IPreKeyInMemoryStore
	public var signedPreKeyStore: SignedPreKeyStore
	
	// MARK: - Init
	public init(storage: YapDatabaseManager, channelStorage: ChannelStorage) {
		sessionStore = SessionInMemoryStore()
		identityStore = IdentityKeyInMemoryStore(storage: storage, channelStorage: channelStorage)
		preKeyStore = PreKeyInMemoryStore(storage: storage, channelStorage: channelStorage)
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
	
	public func deleteKeys(domain: String, clientId: String) {
		identityStore.deleteUserIdentity(domain: domain, clientId: clientId)
		preKeyStore.deletePrekeys(domain: domain, clientId: clientId)
		sessionStore.deleteSessions()
	}
}
