//
//  DecryptsPBKDF2.swift
//  SwiftSRP
//
//  Created by NamNH on 11/03/2022.
//

import Foundation
import CryptoSwift
import CommonCrypto

public class PBKDF2 {
	// MARK: - Variables
	public var iv: [UInt8] = Array("abcdefghijklmnop".utf8)
	private let iterationCount = 1024
	private let keyLength = kCCKeySizeAES256
	private var passPharse: String = ""
	
	// MARK: - Init
	public init() { }
	
	public convenience init(passPharse: String) {
		self.init()
		self.passPharse = passPharse
	}
	
	// MARK: Encrypt & Decrypt
	public func encrypt(data: [UInt8], saltHex: String) -> [UInt8]? {
		do {
			let key = try PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: Array(saltHex.utf8), iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate()
			let enc = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5).encrypt(data)
			let encData = NSData(bytes: enc, length: enc.count ?? 0)
			let base64String: String = encData.base64EncodedString()
			return base64String.bytes
		} catch { print(error) }
		return nil
	}

	public func encrypt(data: [UInt8], saltHex: String, oldIv: String) -> [UInt8]? {
		do {
			let key = try PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: Array(saltHex.utf8), iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate()
			let enc = try AES(key: key, blockMode: CBC(iv: Array(oldIv.utf8)), padding: .pkcs5).encrypt(data)
			let encData = NSData(bytes: enc, length: enc.count ?? 0)
			let base64String: String = encData.base64EncodedString()
			return base64String.bytes
		} catch { print(error) }
		return nil
	}

	public func decrypt(data: [UInt8], saltEncrypt: [UInt8], ivParameterSpec: [UInt8]) -> [UInt8]? {
		guard let key = try? PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: saltEncrypt, iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate(),
			  let enc = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5).decrypt(data) else { return nil }

		let encData = NSData(bytes: enc, length: enc.count)
		let base64String: String = encData.base64EncodedString()
		return base64String.bytes
	}
}
