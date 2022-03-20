//
//  File.swift
//  
//
//  Created by NamNH on 07/03/2022.
//

import Foundation

public protocol ISwiftSRP {
	func getSalt(userName: String, rawPassword: String, byteV: inout UnsafePointer<CUnsignedChar>?) -> [UInt8]?
	func getVerificator(byteV: UnsafePointer<CUnsignedChar>?) -> [UInt8]?
	func getA(userName: String, rawPassword: String, usr: inout OpaquePointer?) -> [UInt8]?
	func getM(salt: [UInt8], byte: [UInt8], usr: OpaquePointer?) async -> [UInt8]?
	func freeMemoryCreateAccount(byteV: inout UnsafePointer<CUnsignedChar>?)
	func freeMemoryAuthenticate(usr: inout OpaquePointer?)
}

public struct SwiftSRP {
	let alg: SRP_HashAlgorithm = SRP_SHA1
	let ngType: SRP_NGType = SRP_NG_2048
	
	var verificatorPtr: UnsafePointer<CUnsignedChar>?
	
	public static let shared = SwiftSRP()
	
	private init() {}
}

// MARK: - Public
extension SwiftSRP: ISwiftSRP {
	public func getSalt(userName: String, rawPassword: String, byteV: inout UnsafePointer<CUnsignedChar>?) -> [UInt8]? {
		var bytesS: UnsafePointer<CUnsignedChar>?
		var lenS: Int32 = 0
		var lenV: Int32 = 0
		var nHex: CChar = 0
		var gHex: CChar = 0
		var password = rawPassword
		userName.withCString({ userNamePtr in
			password.withCString({ passwordPtr in
				passwordPtr.withMemoryRebound(to: UInt8.self, capacity: password.count, { typedPasswordPtr in
					srp_create_salted_verification_key(alg, ngType, userNamePtr, typedPasswordPtr, Int32(rawPassword.count), &bytesS, &lenS, &byteV, &lenV, &nHex, &gHex)
				})
			})
		})
		
		guard let bytesS = bytesS else {
			return nil
		}
		
		let data = Data(bytes: bytesS, count: Int(lenS))
		
		var testPtr = UnsafePointer<CUnsignedChar>(bytesS)
		let endPtr = UnsafePointer<CUnsignedChar>(bytesS) + Int(lenS)
		
		while testPtr < endPtr {
			testPtr += 1
		}
		
		return Array(data)
	}
	
	public func getVerificator(byteV: UnsafePointer<CUnsignedChar>?) -> [UInt8]? {
		guard let byteV = byteV else {
			return nil
		}
		
		let data = Data(bytes: byteV, count: 256)
		
		return Array(data)
	}
	
	public func getA(userName: String, rawPassword: String, usr: inout OpaquePointer?) -> [UInt8]? {
		var nHex: CChar = 0
		var gHex: CChar = 0
		var authUserName: UnsafePointer<CChar>?
		var bytesA: UnsafePointer<CUnsignedChar>?
		var lenA: Int32 = 0
		
		userName.withCString({ userNamePtr in
			rawPassword.withCString({ passwordPtr in
				passwordPtr.withMemoryRebound(to: UInt8.self, capacity: rawPassword.count, { typedPasswordPtr in
					usr = srp_user_new(alg, ngType, userNamePtr, typedPasswordPtr, Int32(rawPassword.count), &nHex, &gHex)
				})
			})
		})
		
		srp_user_start_authentication(usr, &authUserName, &bytesA, &lenA)
		
		guard let bytesA = bytesA else {
			return nil
		}
		
		let data = Data(bytes: bytesA, count: Int(lenA))
		
		return Array(data)
	}
	
	public func getM(salt: [UInt8], byte: [UInt8], usr: OpaquePointer?) async -> [UInt8]? {
		var bytesM: UnsafePointer<CUnsignedChar>?
		var lenM: Int32 = 0
		var bytesS: UnsafePointer<CUnsignedChar>? = await asUnsignedCharArray(bytes: salt)
		var bytesB: UnsafePointer<CUnsignedChar>? = await asUnsignedCharArray(bytes: byte)
		
		srp_user_process_challenge(usr, bytesS, 4, bytesB, 256, &bytesM, &lenM)
		
		guard let bytesS = bytesS else {
			return nil
		}
		
		var testPtr = UnsafePointer<CUnsignedChar>(bytesS)
		let endPtr = UnsafePointer<CUnsignedChar>(bytesS) + 4
		
		while testPtr < endPtr {
			testPtr += 1
		}
		
		guard let bytesM = bytesM else {
			return nil
		}
		
		let data = Data(bytes: bytesM, count: Int(lenM))
		
		guard let bytesB = bytesB else {
			return nil
		}
		
		var testBPtr = UnsafePointer<CUnsignedChar>(bytesB)
		let endBPtr = UnsafePointer<CUnsignedChar>(bytesB) + 256
		
		while testBPtr < endBPtr {
			testBPtr += 1
		}
		
		return Array(data)
	}
	
	public func freeMemoryCreateAccount(byteV: inout UnsafePointer<CUnsignedChar>?) {
		byteV?.deallocate()
		byteV = nil
	}
	
	public func freeMemoryAuthenticate(usr: inout OpaquePointer?) {
		usr = nil
	}
}

// MARK: - Private
private extension SwiftSRP {
	func asUnsignedCharArray(bytes: [UInt8]) async -> UnsafePointer<CUnsignedChar>? {
		let data = Data(bytes: bytes, count: bytes.count)
		
		return await data.withUnsafeBytes { (unsafeBytes) in
			unsafeBytes.bindMemory(to: UInt8.self).baseAddress
		}
	}
}
