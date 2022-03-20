//
//  SignalInMemoryStore.swift
//  ChatSecure
//
//  Created by NamNH on 24/02/2022.
//

import Foundation
import SignalProtocolObjC

class SignalInMemoryStore: NSObject {
	var identityKeyPair: SignalIdentityKeyPair?
	var localRegistrationId: UInt32?
	private var sessionStore: [String: [UInt32: Data]]
	private var preKeyStore: [UInt32: Data]
	private var signedPreKeyStore: [UInt32: Data]
	private var identityKeyStore: [String: Data]
	private var senderKeyStore: [String: Data]
	
	convenience init(identityKeyPair: SignalIdentityKeyPair, localRegistrationId: UInt32) {
		self.init()
		self.identityKeyPair = identityKeyPair
		self.localRegistrationId = localRegistrationId
	}
	
	override init() {
		self.sessionStore = [:]
		self.preKeyStore = [:]
		self.signedPreKeyStore = [:]
		self.identityKeyStore = [:]
		self.senderKeyStore = [:]
	}
}

extension SignalInMemoryStore: SignalStore {
	func getIdentityKeyPair() -> SignalIdentityKeyPair {
		return identityKeyPair ?? SignalIdentityKeyPair()
	}
	
	func getLocalRegistrationId() -> UInt32 {
		return localRegistrationId ?? 0
	}
}

// MARK: - SignalSessionStore
extension SignalInMemoryStore {
	/**
	 * Returns a copy of the serialized session record corresponding to the
	 * provided recipient ID + device ID tuple.
	 * or nil if not found.
	 */
	func sessionRecord(for address: SignalAddress) -> Data? {
		let sessionRecords = sessionStore[address.name] ?? [:]
		return sessionRecords[UInt32(address.deviceId)]
	}
	
	/**
	 * Commit to storage the session record for a given
	 * recipient ID + device ID tuple.
	 *
	 * Return YES on success, NO on failure.
	 */
	func storeSessionRecord(_ recordData: Data, for address: SignalAddress) -> Bool {
		sessionStore[address.name] = [UInt32(address.deviceId): recordData]
		return true
	}
	
	/**
	 * Determine whether there is a committed session record for a
	 * recipient ID + device ID tuple.
	 */
	func sessionRecordExists(for address: SignalAddress) -> Bool {
		return sessionRecordExists(for: address)
	}
	
	/**
	 * Remove a session record for a recipient ID + device ID tuple.
	 */
	func deleteSessionRecord(for address: SignalAddress) -> Bool {
		var sessionRecords = sessionStore[address.name] ?? [:]
		sessionRecords.removeValue(forKey: UInt32(address.deviceId))
		sessionStore[address.name] = sessionRecords
		return true
	}
	
	/**
	 * Returns all known devices with active sessions for a recipient
	 */
	func allDeviceIds(forAddressName addressName: String) -> [NSNumber] {
		let sessionRecords = sessionStore[addressName] ?? [:]
		return sessionRecords.keys.compactMap { NSNumber(value: $0) }
	}
	
	/**
	 * Remove the session records corresponding to all devices of a recipient ID.
	 *
	 * @return the number of deleted sessions on success, negative on failure
	 */
	func deleteAllSessions(forAddressName addressName: String) -> Int32 {
		var sessionRecords = sessionStore[addressName] ?? [:]
		let count = sessionRecords.count
		sessionRecords.removeAll()
		return Int32(count)
	}
}

// MARK: - SignalPreKeyStore
extension SignalInMemoryStore {
	/**
	 * Load a local serialized PreKey record.
	 * return nil if not found
	 */
	func loadPreKey(withId preKeyId: UInt32) -> Data? {
		return preKeyStore[preKeyId]
	}
	
	/**
	 * Store a local serialized PreKey record.
	 * return YES if storage successful, else NO
	 */
	func storePreKey(_ preKey: Data, preKeyId: UInt32) -> Bool {
		preKeyStore[preKeyId] = preKey
		return true
	}
	
	/**
	 * Determine whether there is a committed PreKey record matching the
	 * provided ID.
	 */
	func containsPreKey(withId preKeyId: UInt32) -> Bool {
		return preKeyStore[preKeyId] != nil
	}
	
	/**
	 * Delete a PreKey record from local storage.
	 */
	func deletePreKey(withId preKeyId: UInt32) -> Bool {
		preKeyStore.removeValue(forKey: preKeyId)
		return true
	}
}

// MARK: - SignalSignedPreKeyStore
extension SignalInMemoryStore {
	/**
	 * Load a local serialized signed PreKey record.
	 */
	func loadSignedPreKey(withId signedPreKeyId: UInt32) -> Data? {
		return signedPreKeyStore[signedPreKeyId]
	}
	
	/**
	 * Store a local serialized signed PreKey record.
	 */
	func storeSignedPreKey(_ signedPreKey: Data, signedPreKeyId: UInt32) -> Bool {
		signedPreKeyStore[signedPreKeyId] = signedPreKey
		return true
	}
	
	/**
	 * Determine whether there is a committed signed PreKey record matching
	 * the provided ID.
	 */
	func containsSignedPreKey(withId signedPreKeyId: UInt32) -> Bool {
		return signedPreKeyStore[signedPreKeyId] != nil
	}
	
	/**
	 * Delete a SignedPreKeyRecord from local storage.
	 */
	func removeSignedPreKey(withId signedPreKeyId: UInt32) -> Bool {
		signedPreKeyStore.removeValue(forKey: signedPreKeyId)
		return true
	}
}

// MARK: - SignalIdentityKeyStore
extension SignalInMemoryStore {
	/**
	 * Save a remote client's identity key
	 * <p>
	 * Store a remote client's identity key as trusted.
	 * The value of key_data may be null. In this case remove the key data
	 * from the identity store, but retain any metadata that may be kept
	 * alongside it.
	 */
	func saveIdentity(_ address: SignalAddress, identityKey: Data?) -> Bool {
		identityKeyStore[address.name] = identityKey
		return true
	}
	
	/**
	 * Verify a remote client's identity key.
	 *
	 * Determine whether a remote client's identity is trusted.  Convention is
	 * that the TextSecure protocol is 'trust on first use.'  This means that
	 * an identity key is considered 'trusted' if there is no entry for the recipient
	 * in the local store, or if it matches the saved key for a recipient in the local
	 * store.  Only if it mismatches an entry in the local store is it considered
	 * 'untrusted.'
	 */
	func isTrustedIdentity(_ address: SignalAddress, identityKey: Data) -> Bool {
		guard let existingKey = identityKeyStore[address.name] else { return false }
		return existingKey == identityKey
	}
}

// MARK: - SignalSenderKeyStore
extension SignalInMemoryStore {
	func key(for address: SignalAddress, groupId: String) -> String {
		return String(format: "%@%d%@", address.name, address.deviceId, groupId)
	}
	
	/**
	 * Store a serialized sender key record for a given
	 * (groupId + senderId + deviceId) tuple.
	 */
	func storeSenderKey(_ senderKey: Data, address: SignalAddress, groupId: String) -> Bool {
		let key = key(for: address, groupId: groupId)
		senderKeyStore[key] = senderKey
		return true
	}
	
	/**
	 * Returns a copy of the sender key record corresponding to the
	 * (groupId + senderId + deviceId) tuple.
	 */
	func loadSenderKey(for address: SignalAddress, groupId: String) -> Data? {
		let key = key(for: address, groupId: groupId)
		return senderKeyStore[key]
	}
}
