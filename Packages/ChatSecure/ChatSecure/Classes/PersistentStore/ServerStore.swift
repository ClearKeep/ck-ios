//
//  ServerStore.swift
//  ChatSecure
//
//  Created by NamNH on 10/05/2022.
//

import Foundation
import Common

protocol IServerStore {
	func saveServer(_ server: IServer)
	func getServer(by domain: String) -> IServer?
}

struct ServerStore {
	private var securedStoreService: ISecuredStoreService!
	
	init() {
		securedStoreService = SecuredStoreService()
	}
	
	func getServer(by domain: String) -> IServer? {
		guard let server = securedStoreService.get(key: domain) as? IServer else { return nil }
		return server
	}
	
	func saveServer(_ server: IServer) {
		securedStoreService.set(value: server, key: server.serverDomain)
	}
}
