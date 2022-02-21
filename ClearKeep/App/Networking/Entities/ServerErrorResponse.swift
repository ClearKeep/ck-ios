//
//  ServerErrorResponse.swift
//  iOSBase
//
//  Created by NamNH on 05/10/2021.
//

import Foundation

struct ServerErrorResponse: Codable {
	var statusCode: Int
	var name: String
	var message: String
}
