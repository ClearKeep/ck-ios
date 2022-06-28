//
//  IServerModel.swift
//  Model
//
//  Created by NamNH on 17/05/2022.
//

import Foundation

public protocol IServerModel {
	var serverName: String { get set }
	var serverDomain: String { get set }
	var ownerClientId: String { get set }
	var serverAvatar: String { get set }
	var loginTime: Int64 { get set }
	var accessKey: String { get set }
	var hashKey: String { get set }
	var refreshToken: String { get set }
	var isActive: Bool { get set }
	var profile: IProfileModel? { get set }
}

public protocol IProfileModel {
	var userId: String { get set }
	var userName: String? { get set }
	var email: String? { get set }
	var phoneNumber: String? { get set }
	var updatedAt: Int8 { get set }
	var avatar: String? { get set }
}

public protocol ITokenModel {
	var accessKey: String { get set }
	var refreshToken: String { get set }
}
