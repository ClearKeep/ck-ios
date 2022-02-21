//
//  PersistentStoreService.swift
//  Common
//
//  Created by NamNH on 30/09/2021.
//

import Foundation

public protocol IPersistentStoreService {
	func set<T>(value: T, key: String)
	func get(key: String) -> Any?
	func setObject<T: Codable>(value: T?, key: String)
	func object<T: Codable>(key: String) -> T?
	func remove(key: String)
}

public struct PersistentStoreService: IPersistentStoreService {
	public init() { }
	
	public func set<T>(value: T, key: String) {
		UserDefaults.standard.set(value, forKey: key)
	}
	
	public func get(key: String) -> Any? {
		UserDefaults.standard.value(forKey: key)
	}
	
	public func setObject<T: Codable>(value: T?, key: String) {
		let data = try? JSONEncoder().encode(value)
		UserDefaults.standard.set(data, forKey: key)
	}
	
	public func object<T: Codable>(key: String) -> T? {
		guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
		let object = try? JSONDecoder().decode(T.self, from: data)
		return object
	}
	
	public func remove(key: String) {
		UserDefaults.standard.removeObject(forKey: key)
	}
}
