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
	func signOut(server: RealmServer) async
}

struct HomeRemoteStore {
	let authenticationService: IAuthenticationService
	let groupService: IGroupService
	let messageService: IMessageService
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
	
	func signOut(server: RealmServer) async {
		print("000")
//		await messageService.sendMessageInPeer(senderId: "62636bbb-6316-4017-8478-deef55b93a4d", ownerWorkspace: "develop1.clearkeep.org:25000", receiverId: "84e7b891-6022-4881-86b8-92c093ceeb31", receiverWorkSpaceDomain: "develop1.clearkeep.org:25000", groupId: Int64(2), plainMessage: "kkkk", isForceProcessKey: false, cachedMessageId: 0)
		await messageService.getMessage(server: server, groupId: Int64(2), loadSize: 10, lastMessageAt: 0)
	}
}
