//
//  APIConfigurations.swift
//  iOSBase
//
//  Created by NamNH on 04/10/2021.
//

import Foundation
import Networking

// swiftlint:disable force_unwrapping
struct APIConfigurations: IAPIConfigurations {
	var apiKey: String {
		return ""
	}
	
	var endpoint: URL {
		return URL(string: "https://code4fun.group")!
	}
}
