//
//  SecuredStoreService.swift
//  Common
//
//  Created by NamNH on 02/11/2021.
//

import Foundation
import KeychainAccess

public protocol ISecuredStoreService: IPersistentStoreService { }

public struct SecuredStoreService: ISecuredStoreService {
	private var store: Keychain!
	
	public init() {
		self.store = Keychain()
	}
	
	public func set<T>(value: T, key: String) {
		store[key] = value as? String
	}
	
	public func get(key: String) -> Any? {
		return store[key]
	}
	
	public func setObject<T: Codable>(value: T?, key: String) {
		guard let data = try? JSONEncoder().encode(value) else { return }
		try? store.set(data, key: key)
	}
	
	public func object<T: Codable>(key: String) -> T? {
		guard let data = try? store.getData(key) else { return nil }
		let object = try? JSONDecoder().decode(T.self, from: data)
		return object
	}
	
	public func remove(key: String) {
		try? store.remove(key)
	}
}
