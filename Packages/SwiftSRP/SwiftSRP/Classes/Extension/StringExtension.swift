//
//  StringExtension.swift
//  SwiftSRP
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

extension String {
	public var asciiArray: [UInt32] {
		return unicodeScalars.filter { $0.isASCII }.map { $0.value }
	}
	
	public func hashCode() -> Int32 {
		var hash: Int32 = 0
		for index in self.asciiArray {
			hash = 31 &* hash &+ Int32(index)
		}
		return hash
	}
}
