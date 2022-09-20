//
//  SessionInMemoryStore.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import LibSignalClient

public protocol ISessionInMemoryStore: SessionStore {
	func deleteSessions()
}

final class SessionInMemoryStore {
	// MARK: - Variables
	private var sessionMap: [ProtocolAddress: SessionRecord] = [:]
	
}

extension SessionInMemoryStore: ISessionInMemoryStore {
	func loadSession(for address: ProtocolAddress, context: StoreContext) throws -> SessionRecord? {
		return sessionMap[address]
	}
	
	func loadExistingSessions(for addresses: [ProtocolAddress], context: StoreContext) throws -> [SessionRecord] {
		return try addresses.map { address in
			if let session = sessionMap[address] {
				return session
			}
			throw SignalError.sessionNotFound("\(address)")
		}
	}
	
	func storeSession(_ record: SessionRecord, for address: ProtocolAddress, context: StoreContext) throws {
		sessionMap[address] = record
	}
	
	func deleteSessions() {
		sessionMap.removeAll()
	}
}
