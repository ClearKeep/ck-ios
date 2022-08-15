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
	func getListStatus(domain: String, data: [[String: String]]) async -> Result<IHomeModels, Error>
	func signOut(domain: String) async -> Result<HomeModels, Error>
	func pingServer(domain: String) async
	func changeStatus(domain: String, status: String) async -> Result<IHomeModels?, Error>
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
	
	func getListStatus(domain: String, data: [[String: String]]) async -> Result<IHomeModels, Error> {
		let result = await userService.getListStatus(data: data, domain: domain)
		switch result {
		case .success(let response):
			let client = response.lstClient.first(where: { $0.clientID == DependencyResolver.shared.channelStorage.currentServer?.profile?.userId })
			return .success(HomeModels(responseUser: client, members: response.lstClient))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func pingServer(domain: String) async {
		_ = await userService.pingRequest(domain: domain)
	}
	
	func changeStatus(domain: String, status: String) async -> Result<IHomeModels?, Error> {
		let result = await userService.updateStatus(status: status, domain: domain)
		switch result {
		case .success:
			return .success(nil)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signOut(domain: String) async -> Result<HomeModels, Error> {
		let result = await authenticationService.logoutFromAPI(domain: domain)
		switch result {
		case .success(let response):
			return .success(HomeModels(responeAuthen: response))
		case .failure(let error):
			return .failure(error)
		}
	}
}
