//
//  INormalLoginModel.swift
//  Model
//
//  Created by NamNH on 29/04/2022.
//

import UIKit

public protocol INormalLoginModel {
	var workspaceDomain: String? { get }
	var workspaceName: String? { get }
	var accessToken: String? { get }
	var expiresIn: Int64? { get }
	var refreshExpiresIn: Int64? { get }
	var refreshToken: String? { get }
	var tokenType: String? { get }
	var sessionState: String? { get }
	var scope: String? { get }
	var salt: String? { get }
	var clientKeyPeer: IClientKeyPeerModel? { get }
	var ivParameter: String? { get }
	var sub: String? { get }
	var otpHash: String? { get }
}

public protocol IClientKeyPeerModel {
	var clientId: String? { get }
	var workspaceDomain: String? { get }
	var registrationId: Int32? { get }
	var deviceId: Int32? { get }
	var identityKeyPublic: Data { get }
	var preKeyId: Int32? { get }
	var preKey: Data { get }
	var signedPreKeyId: Int32? { get }
	var signedPreKey: Data { get }
	var signedPreKeySignature: Data { get }
	var identityKeyEncrypted: String? { get }
}
