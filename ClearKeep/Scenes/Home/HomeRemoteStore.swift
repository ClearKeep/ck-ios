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
//		await messageService.sendMessageInPeer(senderId: "8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65", ownerWorkspace: "stag1.clearkeep.org:25000", receiverId: "8e32813b-01b8-4c6a-bec7-0ff5c5460e20", receiverWorkSpaceDomain: "stag1.clearkeep.org:25000", groupId: Int64(13), plainMessage: "helloo", isForceProcessKey: false, cachedMessageId: 0)
		await messageService.getMessage(server: server, groupId: Int64(14), loadSize: 10, lastMessageAt: 0)
//        await messageService.sendMessageInGroup(senderId: "8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65", ownerWorkspace: "stag1.clearkeep.org:25000", groupId: Int64(14), plainMessage: "kkkk", cachedMessageId: 0)
	}
}
