//
//  UserService.swift
//  ChatSecure
//
//  Created by NamNH on 28/04/2022.
//

import Foundation
import Networking

public protocol IUserService {
	func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error>
}

public class UserService {
	
	public init() {
	}
}

extension UserService: IUserService {
	public func getProfile(domain: String) async -> Result<User_UserProfileResponse, Error> {
		let request = User_Empty()
		return await channelStorage.getChannel(domain: domain).getProfile(request)
	}
	
}
