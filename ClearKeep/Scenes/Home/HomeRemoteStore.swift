//
//  HomeRemoteStore.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import Foundation
import Combine
import ChatSecure

protocol IHomeRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<Bool, Error>
	func signOut() async
}

struct HomeRemoteStore {
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
}

extension HomeRemoteStore: IHomeRemoteStore {
	func getJoinedGroup(domain: String) async -> Result<Bool, Error> {
		let result = await groupService.getJoinedGroups(domain: domain)
		
		switch result {
		case .success(let response):
			print(response)
			return .success(true)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func signOut() async {
	}
}
