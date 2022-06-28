//
//  HomeRemoteStore.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Foundation
import Combine
import ChatSecure
import Model

protocol IHomeRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<IHomeModels, Error>
	func getProfile(domain: String) async -> Result<IHomeModels, Error>
	func signOut(domain: String) async -> Result <Bool, Error>
	func refreshToken(domain: String) async -> Result<ITokenModel, Error>
	func subscribeAndListenServers(domain: String)
}

struct HomeRemoteStore {
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
	let clientStore: ClientStore
}

extension HomeRemoteStore: IHomeRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<IHomeModels, Error> {
		let result = await groupService.getJoinedGroups(domain: domain)
		
		switch result {
		case .success(let realmGroups):
			let groups = realmGroups.compactMap { group in
				GroupModel(group)
			}
			return .success(HomeModels(responseGroup: groups))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getProfile(domain: String) async -> Result<IHomeModels, Error> {
		let result = await userService.getProfile(domain: domain)
		
		switch result {
		case .success(let user):
			return .success(HomeModels(responseUser: user))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signOut(domain: String) async -> Result<Bool, Error> {
		let result = await authenticationService.logoutFromAPI(domain: domain)
		
		switch result {
		case .success(let value):
			print(value)
			return .success(true)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func refreshToken(domain: String) async -> Result<ITokenModel, Error> {
		let result = await authenticationService.refreshToken(domain: domain)
		
		switch result {
		case .success(let data):
			print("Refresh token success \(data)")
			return .success(TokenModel(accessKey: data.accessToken, refreshToken: data.refreshToken))
		case .failure(let error):
			print("Refresh token fail \(error)")
			return .failure(error)
		}
	}
	
	func subscribeAndListenServers(domain: String) {
		let subscribeAndListenService = SubscribeAndListenService(clientStore: self.clientStore)
		subscribeAndListenService.subscribe(domain)
	}
}
