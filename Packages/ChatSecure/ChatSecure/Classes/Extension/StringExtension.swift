//
//  StringExtension.swift
//  ChatSecure
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

extension String {
	var decodeHex: [UInt8] {
		let stringArray = Array(self)
		var data: Data = Data()
		for index in stride(from: 0, to: self.count, by: 2) {
			let pair: String = String(stringArray[index]) + String(stringArray[index + 1])
			if let byteNum = UInt8(pair, radix: 16) {
				let byte = Data([byteNum])
				data.append(byte)
			} else {
				fatalError()
			}
		}
		return Array(data).devided().1
	}
	
	var asciiArray: [UInt32] {
		return unicodeScalars.filter { $0.isASCII }.map { $0.value }
	}
	
	func hashCode() -> Int32 {
		var hash: Int32 = 0
		for index in self.asciiArray {
			hash = 31 &* hash &+ Int32(index)
		}
		return hash
	}
}
