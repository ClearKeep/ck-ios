//
//  NetworkResponseErrorBuilder.swift
//  Networking
//
//  Created by NamNH on 02/10/2021.
//

import Foundation

public protocol INetworkResponseErrorBuilder {
	static func build(data: Data?, response: HTTPURLResponse?, error: Error?) -> Error
}
