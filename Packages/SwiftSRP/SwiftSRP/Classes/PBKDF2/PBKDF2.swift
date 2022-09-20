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
			let key = try PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: saltHex.hexaBytes, iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate()
			let enc = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5).encrypt(data)
			return enc
		} catch { print(error) }
		return nil
	}

	public func encrypt(data: [UInt8], saltHex: String, oldIv: String) -> [UInt8]? {
		do {
			let key = try PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: saltHex.hexaBytes, iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate()
			let enc = try AES(key: key, blockMode: CBC(iv: oldIv.hexaBytes), padding: .pkcs5).encrypt(data)
			return enc
		} catch { print(error) }
		return nil
	}

	public func decrypt(data: [UInt8], saltEncrypt: [UInt8], ivParameterSpec: [UInt8]) -> [UInt8]? {
		guard let key = try? PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: saltEncrypt, iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate(),
			  let enc = try? AES(key: key, blockMode: CBC(iv: ivParameterSpec), padding: .pkcs5).decrypt(data) else { return nil }
		return enc
	}
	
	public func decrypt(data: [UInt8], saltHex: String, ivParameterSpec: String) -> [UInt8]? {
		guard let key = try? PKCS5.PBKDF2(password: Array(passPharse.utf8), salt: saltHex.hexaBytes, iterations: iterationCount, keyLength: keyLength, variant: .sha1).calculate(),
			  let enc = try? AES(key: key, blockMode: CBC(iv: ivParameterSpec.hexaBytes), padding: .pkcs5).decrypt(data) else { return nil }
		return enc
	}
}
