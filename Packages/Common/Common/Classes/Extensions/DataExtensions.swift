//
//  DataExtensions.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

public extension Data {
	var stringUTF8: String? {
		String(data: self, encoding: .utf8)
	}
}
