//
//  NetworkResponseErrorBuilder.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public struct NetworkResponseErrorBuilder {
	public static func build(data: Data?, response: HTTPURLResponse?, error: Error?) -> Error {
		let responseError = (error as NSError?) ?? NSError()
		
		var userInfo = responseError.userInfo
		userInfo["statusCode"] = response?.statusCode
		userInfo["responseData"] = data
		userInfo["response"] = response
		
		return NSError(domain: responseError.domain, code: response?.statusCode ?? responseError.code, userInfo: userInfo)
	}
}
