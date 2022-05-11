//
//  ITokenService.swift
//  Networking
//
//  Created by NamNH on 08/11/2021.
//

import UIKit

public protocol ITokenService {
	var uid: String? { get set }
	var accessToken: String? { get set }
	
	func clearToken()
}

public class TokenServiceHelper {
	public static func decode(jwtToken jwt: String) -> Data? {
		let segments = jwt.components(separatedBy: ".")
		return base64UrlDecode(segments[1])
	}
	
	private static func base64UrlDecode(_ value: String) -> Data? {
		var base64 = value
			.replacingOccurrences(of: "-", with: "+")
			.replacingOccurrences(of: "_", with: "/")
		
		let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
		let requiredLength = 4 * ceil(length / 4.0)
		let paddingLength = requiredLength - length
		if paddingLength > 0 {
			let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
			base64 += padding
		}
		return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
	}
}
