//
//  YapDatabaseManager.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 23/05/2022.
//

import Foundation
import YapDatabase

enum YapDatabaseCollection {
	case `default`
	
	var name: String {
		switch self {
		case .default:
			return "default"
		}
	}
}

public final class YapDatabaseManager {
	// MARK: - Variables
	private let database: YapDatabase?
	
	let readConnection: YapDatabaseConnection?
	let writeConnection: YapDatabaseConnection?
	
	// MARK: - Init
	public init(databasePath: URL) {
		let options = YapDatabaseOptions()
		options.enableMultiProcessSupport = true
		database = YapDatabase(url: databasePath, options: options)
		
		database?.connectionDefaults.objectCacheLimit = 250
		database?.connectionDefaults.metadataCacheEnabled = false
		database?.connectionDefaults.objectCacheEnabled = false
		
		readConnection = database?.newConnection()
		readConnection?.objectCacheEnabled = true

		writeConnection = database?.newConnection()
	}
}

extension YapDatabaseManager {
	
	func insert(_ object: Any, forKey key: String, collection: YapDatabaseCollection = .default) {
		writeConnection?.readWrite { (transaction) in
			transaction.setObject(object, forKey: key, inCollection: collection.name)
		}
	}
		
	func object<T>(forKey key: String, collection: YapDatabaseCollection = .default) -> T? {
		var result: T?
		readConnection?.read { (transaction) in
			result = transaction.object(forKey: key, inCollection: collection.name) as? T
		}
		return result
	}
		
	func remove(_ forKey: String, collection: YapDatabaseCollection = .default) {
		writeConnection?.readWrite { (transaction) in
			transaction.removeObject(forKey: forKey, inCollection: collection.name)
		}
	}
	
	func removeAllObjects(collection: YapDatabaseCollection = .default) {
		writeConnection?.readWrite { (transaction) in
			transaction.removeAllObjects(inCollection: collection.name)
		}
	}
	
	func removeAllObjectsInAllCollections() {
		writeConnection?.readWrite { (transaction) in
			transaction.removeAllObjectsInAllCollections()
		}
	}
}
