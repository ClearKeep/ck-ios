//
//  Configuration.swift
//  ClearKeep
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

enum Configuration {
	enum Error: Swift.Error {
		case missingKey, invalidValue
	}
	
	static func value<T>(for key: String) -> T where T: LosslessStringConvertible {
		guard let object = Bundle.app.object(forInfoDictionaryKey: key) else {
			fatalError("missing key \(key)")
		}

		switch object {
		case let value as T: return value
		case let string as String:
			guard let value = T(string) else { fallthrough }
			return value
		default: fatalError("Invalid value for \(key)")
		}
	}
}

extension Bundle {
	/// Return the main bundle when in the app or an app extension.
	static var app: Bundle {
		var components = main.bundleURL.path.split(separator: "/")
		var bundle: Bundle?

		if let index = components.lastIndex(where: { $0.hasSuffix(".app") }) {
			components.removeLast((components.count - 1) - index)
			bundle = Bundle(path: components.joined(separator: "/"))
		}

		return bundle ?? main
	}
}
