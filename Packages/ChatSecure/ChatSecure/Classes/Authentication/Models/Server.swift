//
//  Server.swift
//  
//
//  Created by NamNH on 11/03/2022.
//

import UIKit

public protocol IServer {
	var id: Int? { get set }
	var serverName: String { get set }
	var serverDomain: String { get set }
	var ownerClientId: String { get set }
	var serverAvatar: String { get set }
	var loginTime: Int8 { get set }
	var accessKey: String { get set }
	var hashKey: String { get set }
	var refreshToken: String { get set }
	var isActive: Bool { get set }
	var profile: IProfile { get set }
}

struct Server {

}
