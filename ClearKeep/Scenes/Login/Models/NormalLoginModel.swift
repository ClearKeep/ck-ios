//
//  NormalLoginModel.swift
//  ClearKeep
//
//  Created by NamNH on 29/04/2022.
//

import Model
import Networking

struct NormalLoginModel: INormalLoginModel {
	var workspaceDomain: String?
	var workspaceName: String?
	var accessToken: String?
	var expiresIn: Int64?
	var refreshExpiresIn: Int64?
	var refreshToken: String?
	var tokenType: String?
	var sessionState: String?
	var scope: String?
	var salt: String?
	var clientKeyPeer: IClientKeyPeerModel?
	var ivParameter: String?
	
	init(workspaceDomain: String? = nil,
				  workspaceName: String? = nil,
				  accessToken: String? = nil,
				  expiresIn: Int64? = nil,
				  refreshExpiresIn: Int64? = nil,
				  refreshToken: String? = nil,
				  tokenType: String? = nil,
				  sessionState: String? = nil,
				  scope: String? = nil,
				  salt: String? = nil,
				  clientKeyPeer: IClientKeyPeerModel? = nil,
				  ivParameter: String? = nil) {
		self.workspaceDomain = workspaceDomain
		self.workspaceName = workspaceName
		self.accessToken = accessToken
		self.expiresIn = expiresIn
		self.refreshExpiresIn = refreshExpiresIn
		self.refreshToken = refreshToken
		self.tokenType = tokenType
		self.sessionState = sessionState
		self.scope = scope
		self.salt = salt
		self.clientKeyPeer = clientKeyPeer
		self.ivParameter = ivParameter
	}
}

struct ClientKeyPeerModel: IClientKeyPeerModel {
	var clientId: String?
	var workspaceDomain: String?
	var registrationId: Int32?
	var deviceId: Int32?
	var identityKeyPublic: Data
	var preKeyId: Int32?
	var preKey: Data
	var signedPreKeyId: Int32?
	var signedPreKey: Data
	var signedPreKeySignature: Data
	var identityKeyEncrypted: String?
	
	init(clientId: String? = nil,
		 workspaceDomain: String? = nil,
		 registrationId: Int32? = nil,
		 deviceId: Int32? = nil,
		 identityKeyPublic: Data,
		 preKeyId: Int32? = nil,
		 preKey: Data,
		 signedPreKeyId: Int32? = nil,
		 signedPreKey: Data,
		 signedPreKeySignature: Data,
		 identityKeyEncrypted: String? = nil) {
		self.clientId = clientId
		self.workspaceDomain = workspaceDomain
		self.registrationId = registrationId
		self.deviceId = deviceId
		self.identityKeyPublic = identityKeyPublic
		self.preKeyId = preKeyId
		self.preKey = preKey
		self.signedPreKeyId = signedPreKeyId
		self.signedPreKey = signedPreKey
		self.signedPreKeySignature = signedPreKeySignature
		self.identityKeyEncrypted = identityKeyEncrypted
	}
}

extension NormalLoginModel {
	init(response: Auth_AuthRes) {
		let clientKeyPeer = ClientKeyPeerModel(response: response.clientKeyPeer)
		
		self.init(workspaceDomain: response.workspaceDomain,
				  workspaceName: response.workspaceName,
				  accessToken: response.accessToken,
				  expiresIn: response.expiresIn,
				  refreshExpiresIn: response.refreshExpiresIn,
				  refreshToken: response.refreshToken,
				  tokenType: response.tokenType,
				  sessionState: response.sessionState,
				  scope: response.scope,
				  salt: response.salt,
				  clientKeyPeer: clientKeyPeer,
				  ivParameter: response.ivParameter)
	}
}

extension ClientKeyPeerModel {
	init(response: Auth_PeerGetClientKeyResponse) {
		self.init(clientId: response.clientID,
				  workspaceDomain: response.workspaceDomain,
				  registrationId: response.registrationID,
				  deviceId: response.deviceID,
				  identityKeyPublic: response.identityKeyPublic,
				  preKeyId: response.preKeyID,
				  preKey: response.preKey,
				  signedPreKeyId: response.signedPreKeyID,
				  signedPreKey: response.signedPreKey,
				  signedPreKeySignature: response.signedPreKeySignature,
				  identityKeyEncrypted: response.identityKeyEncrypted)
	}
}
