//
//  String+Extensions.swift
//  ClearKeep
//
//  Created by HOANDHTB on 13/07/2022.
//

import Foundation
import CommonCrypto

extension Data {
	public func sha256() -> String {
		return hexStringFromData(input: digest(input: self as NSData))
	}
	
	private func digest( input : NSData ) -> NSData {
		let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
		var hash = [UInt8](repeating: 0, count: digestLength)
		CC_SHA256(input.bytes, UInt32(input.length), &hash)
		return NSData(bytes: hash, length: digestLength)
	}
	
	private func hexStringFromData(input: NSData) -> String {
		var bytes = [UInt8](repeating: 0, count: input.length)
		input.getBytes(&bytes, length: input.length)
		
		var hexString = ""
		for byte in bytes {
			hexString += String(format: "%02x", UInt8(byte))
		}
		
		return hexString
	}
}

public extension String {
	fileprivate var emailPredicate: NSPredicate {
		NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
	}
	
	func sha256() -> String {
		if let stringData = self.data(using: String.Encoding.utf8) {
			return stringData.sha256()
		}
		return ""
	}
	
	var validEmail: Bool {
		self.emailPredicate.evaluate(with: self)
	}
}
