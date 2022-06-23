//
//  NSRegularExpressionExtensions.swift
//  Common
//
//  Created by Quang Pham on 20/06/2022.
//

import Foundation

public extension NSRegularExpression {
	convenience init(_ pattern: String) {
		do {
			try self.init(pattern: pattern)
		} catch {
			preconditionFailure("Illegal regular expression: \(pattern).")
		}
	}
	
	func matches(_ string: String) -> Bool {
		let range = NSRange(location: 0, length: string.utf16.count)
		return firstMatch(in: string, options: [], range: range) != nil
	}
	
	func matchList(_ string: String) -> [String] {
		let range = NSRange(location: 0, length: string.utf16.count)
		let results = matches(in: string, options: [], range: range)
		return results.map { NSString(string: string).substring(with: $0.range) }.filter { !$0.isEmpty }
	}
}
