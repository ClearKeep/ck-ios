//
//  RealmListDetachable.swift
//  ClearKeep
//
//  Created by HOANDHTB on 29/07/2022.
//

import UIKit
import Realm
import RealmSwift

protocol RealmListDetachable {
	
	func detached() -> Self
}

extension List: RealmListDetachable where Element: Object {
	
	func detached() -> List<Element> {
		let detached = self.detached
		let result = List<Element>()
		result.append(objectsIn: detached)
		return result
	}
	
}

@objc extension Object {
	
	public func detached() -> Self {
		let detached = type(of: self).init()
		for property in objectSchema.properties {
			guard
				property != objectSchema.primaryKeyProperty,
				let value = value(forKey: property.name)
			else { continue }
			if let detachable = value as? Object {
				detached.setValue(detachable.detached(), forKey: property.name)
			} else if let list = value as? RealmListDetachable {
				detached.setValue(list.detached(), forKey: property.name)
			} else {
				detached.setValue(value, forKey: property.name)
			}
		}
		return detached
	}
}

extension Sequence where Iterator.Element: Object {
	
	public var detached: [Element] {
		return self.map({ $0.detached() })
	}
	
}
