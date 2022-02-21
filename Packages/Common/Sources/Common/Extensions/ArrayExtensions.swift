//
//  ArrayExtensions.swift
//  Common
//
//  Created by NamNH on 30/11/2021.
//

import Foundation

public extension Array {
	subscript (safe index: Index) -> Element? {
		return 0 <= index && index < count ? self[index] : nil
	}
}

public extension Array where Element: Hashable {
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
}
