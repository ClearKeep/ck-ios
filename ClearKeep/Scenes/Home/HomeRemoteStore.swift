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
	func getJoinedGroup(domain: String) async -> Result<[IGroupModel], Error>
	func signOut() async
}

struct HomeRemoteStore {
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
}

extension HomeRemoteStore: IHomeRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<[IGroupModel], Error> {
		let result = await groupService.getJoinedGroups(domain: domain)
		
		switch result {
		case .success(let realmGroups):
			let groups = realmGroups.compactMap { group in
				GroupModel(group)
			}
			return .success(groups)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signOut() async {
	}
}
