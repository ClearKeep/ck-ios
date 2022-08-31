//
//  TempServer.swift
//  ChatSecure
//
//  Created by Quang Pham on 22/08/2022.
//

import Foundation

public struct TempServer {
	public var serverDomain: String
	public var ownerClientId: String
	
	public init(serverDomain: String, ownerClientId: String) {
		self.serverDomain = serverDomain
		self.ownerClientId = ownerClientId
	}
}
