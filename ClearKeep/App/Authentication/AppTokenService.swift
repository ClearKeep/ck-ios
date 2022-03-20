//
//  TokenService.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import Common
import ChatSecure

protocol IAppTokenService: ITokenService {
}

class AppTokenService {
	let securedStoreService: ISecuredStoreService
	let persistentStoreService: IPersistentStoreService
	
	init(securedStoreService: ISecuredStoreService,
		 persistentStoreService: IPersistentStoreService) {
		self.securedStoreService = securedStoreService
		self.persistentStoreService = persistentStoreService
	}
}

extension AppTokenService: IAppTokenService {
	var uid: String? {
		get {
			return securedStoreService.get(key: "uid") as? String
		}
		set {
			securedStoreService.set(value: newValue, key: "uid")
		}
	}
	
	var accessToken: String? {
		get {
			return securedStoreService.get(key: "accessToken") as? String
		}
		set {
			securedStoreService.set(value: newValue, key: "accessToken")
		}
	}
	
	func clearToken() {
		self.uid = nil
		self.accessToken = nil
	}
}
