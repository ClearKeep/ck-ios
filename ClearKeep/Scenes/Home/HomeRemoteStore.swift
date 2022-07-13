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
	func getListStatus(domain: String, userId: String) async -> Result<IHomeModels, Error>
	func signOut() async
}

struct HomeRemoteStore {
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let userService: IUserService
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
	
	func getListStatus(domain: String, userId: String) async -> Result<IHomeModels, Error> {
		let result = await userService.getListStatus(clientID: userId, workspaceDomain: domain, domain: domain)
		switch result {
		case .success(let response):
			let client = response.lstClient.first(where: { $0.clientID == userId })
			return .success(HomeModels(responseUser: client))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signOut() async {
	}
}
