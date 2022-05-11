//
//  UserService.swift
//  ChatSecure
//
//  Created by NamNH on 28/04/2022.
//

import Foundation
import Networking

protocol IUserService {
	func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error>
}

class UserService {
	var clientStore: ClientStore
	
	public init() {
		clientStore = ClientStore()
	}
}

extension UserService: IUserService {
	func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error> {
		let request = User_Empty()
		return await channelStorage.getChannel(domain: domain).getProfile(request)
	}
	
}
