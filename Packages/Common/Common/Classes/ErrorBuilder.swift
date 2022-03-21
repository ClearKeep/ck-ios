//
//  ErrorBuilder.swift
//  Common
//
//  Created by NamNH on 01/11/2021.
//

import Foundation

public struct ErrorBuilder {
	public static func build(_ message: String?) -> Error {
		let userInfo: [String: Any] = ["message": message ?? ""]
		return NSError(domain: "", code: 0, userInfo: userInfo)
	}
}
