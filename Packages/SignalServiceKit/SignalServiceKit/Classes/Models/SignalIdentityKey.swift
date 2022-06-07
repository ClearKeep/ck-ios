//
//  SignalIdentityKey.swift
//  SignalServiceKit
//
//  Created by Quang Pham on 24/05/2022.
//

import Foundation

public struct SignalIdentityKey: Codable {
	let identityKeyPair: Data
	let registrationId: UInt32
	let domain: String
	let userId: String
	
	public init(identityKeyPair: Data,
		 registrationId: UInt32,
		 domain: String,
		 userId: String
	) {
		self.identityKeyPair = identityKeyPair
		self.registrationId = registrationId
		self.domain = domain
		self.userId = userId
	}
}
