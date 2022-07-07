//
//  MD5.swift
//  CommonUI
//
//  Created by MinhDev on 06/07/2022.
//

import Foundation
import CommonCrypto

public func md5(imageData: Data) -> String {
	var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
	do {
		imageData.withUnsafeBytes { bytes in
			CC_MD5(bytes, CC_LONG(imageData.count), &digest)
		}
		var digestHex = ""
		for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
			digestHex += String(format: "%02hhx", digest[index])
		}
		return digestHex
	} catch let error as Error {
		return String()
	}
}

public func getFormattedDate(date: Date, format: String) -> String {
	let dateformat = DateFormatter()
	dateformat.dateFormat = format
	return dateformat.string(from: date)
}
