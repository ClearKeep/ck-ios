//
//  IdentityKeyInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 23/05/2022.
//

import SignalServiceKit
import LibSignalClient

public protocol IIdentityKeyInMemoryStore: IdentityKeyStore {
	func saveUserIdentity(identity: SignalIdentityKey) throws
	func deleteUserIdentity(domain: String, clientId: String)
}

final class IdentityKeyInMemoryStore {
	// MARK: - Variables
	private let storage: YapDatabaseManager
	private let channelStorage: ChannelStorage
	private var identityKeys: [String: SignalIdentityKey] = [:]
	private var publicKeys: [ProtocolAddress: IdentityKey] = [:]
	
	// MARK: - Init
	init(storage: YapDatabaseManager, channelStorage: ChannelStorage) {
		self.storage = storage
		self.channelStorage = channelStorage
	}
	
	private func getIdentityKey() -> SignalIdentityKey? {
		do {
			let currrentServer = channelStorage.tempServer
			let clientId = currrentServer?.ownerClientId ?? channelStorage.currentServer?.ownerClientId ?? ""
			let domain = currrentServer?.serverDomain ?? channelStorage.currentDomain
			if let tempKey = identityKeys[clientId + domain] {
				return tempKey
			}
			let jsonDecoder = JSONDecoder()
			if let keyData: Data = storage.object(forKey: clientId + domain, collection: .domain(domain)) {
				let key = try jsonDecoder.decode(SignalIdentityKey.self, from: keyData)
				identityKeys[clientId + domain] = key
				return key
			} else {
				return nil
			}
		} catch {
			return nil
		}
	}
	
	private func getIdentityKeyPair() throws -> IdentityKeyPair {
		if let key = getIdentityKey() {
			return try IdentityKeyPair(bytes: key.identityKeyPair)
		} else {
			throw SignalError.invalidKey("IndentityKey not found")
		}
	}
	
	private func getRegistrationId() throws -> UInt32 {
		if let key = getIdentityKey() {
			return key.registrationId
		} else {
			throw SignalError.invalidKey("IndentityKey not found")
		}
	}
}

extension IdentityKeyInMemoryStore: IIdentityKeyInMemoryStore {
	func saveUserIdentity(identity: SignalIdentityKey) throws {
		let jsonEncoder = JSONEncoder()
		let identityData = try jsonEncoder.encode(identity)
		identityKeys[identity.userId + identity.domain] = identity
		storage.insert(identityData, forKey: identity.userId + identity.domain, collection: .domain(identity.domain))
	}
	
	func identityKeyPair(context: StoreContext) throws -> IdentityKeyPair {
		return try getIdentityKeyPair()
	}
	
	func localRegistrationId(context: StoreContext) throws -> UInt32 {
		return try getRegistrationId()
	}
	
	func saveIdentity(_ identity: IdentityKey, for address: ProtocolAddress, context: StoreContext) throws -> Bool {
		if publicKeys.updateValue(identity, forKey: address) == nil {
			return false
		} else {
			return true
		}
	}
	
	func isTrustedIdentity(_ identity: IdentityKey, for address: ProtocolAddress, direction: Direction, context: StoreContext) throws -> Bool {
		if let publicKey = publicKeys[address] {
			return publicKey == identity
		} else {
			return true
		}
	}
	
	func identity(for address: ProtocolAddress, context: StoreContext) throws -> IdentityKey? {
		publicKeys[address]
	}
	
	func deleteUserIdentity(domain: String, clientId: String) {
		storage.removeAllObjects(collection: .domain(domain))
		publicKeys.removeAll()
		identityKeys.removeAll()
	}
}
