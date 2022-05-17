//
//  ServerViewModel.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import Foundation
import Model

struct ServerViewModel: Identifiable {
	var id: String { "\(serverDomain)" }
	var serverName: String
	var serverDomain: String
	var ownerClientId: String
	var imageURL: URL?
	
	init(_ server: IServerModel) {
		serverName = server.serverName
		serverDomain = server.serverDomain
		ownerClientId = server.ownerClientId
		imageURL = URL(string: server.serverAvatar)
	}
}
