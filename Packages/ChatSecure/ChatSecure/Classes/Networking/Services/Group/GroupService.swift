//
//  GroupService.swift
//  ChatSecure
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Networking
import LibSignalClient
import SwiftSRP
import Common

public protocol IGroupService {
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [Group_ClientInGroupObject], domain: String) async -> (Result<Group_GroupObjectResponse, Error>)
	func searchGroups(_ keyword: String, domain: String) async -> (Result<Group_SearchGroupsResponse, Error>)
	func getGroup(by groupId: Int64, domain: String) async -> (Result<RealmGroup, Error>)
	func getJoinedGroups(domain: String) async -> (Result<[RealmGroup], Error>)
	func joinGroup(by groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>)
	func addMember(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>)
	func leaveGroup(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>)

}

public class GroupService {
	private let senderStore: ISenderKeyStore
	private let signalStore: ISignalProtocolInMemoryStore
	
	public init(senderStore: ISenderKeyStore, signalStore: ISignalProtocolInMemoryStore) {
		self.senderStore = senderStore
		self.signalStore = signalStore
	}
}

extension GroupService: IGroupService {

	public func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [Group_ClientInGroupObject], domain: String) async -> (Result<Group_GroupObjectResponse, Error>) {

		var request = Group_CreateGroupRequest()
		request.groupName = groupName
		request.groupType = groupType
		request.lstClient = lstClient
		request.createdByClientID = clientId
		
		return await channelStorage.getChannel(domain: domain).createGroup(request)
	}
	
	public func searchGroups(_ keyword: String, domain: String) async -> (Result<Group_SearchGroupsResponse, Error>) {
		var request = Group_SearchGroupsRequest()
		request.keyword = keyword
		
		return await channelStorage.getChannel(domain: domain).searchGroups(request)
	}
	
	public func getGroup(by groupId: Int64, domain: String) async -> (Result<RealmGroup, Error>) {
		var request = Group_GetGroupRequest()
		request.groupID = groupId
		let response = await channelStorage.getChannel(domain: domain).getGroup(request)
		
		switch response {
		case .success(let data):
			return await .success(channelStorage.realmManager.addAndUpdateGroup(group: data, domain: domain))
		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func getJoinedGroups(domain: String) async -> (Result<[RealmGroup], Error>) {
		let request = Group_GetJoinedGroupsRequest()

		let response = await channelStorage.getChannel(domain: domain).getJoinedGroups(request)
		
		switch response {
		case .success(let data):
			print(data)
			let server = channelStorage.realmManager.getServer(by: domain)
			guard let server = server, let profile = server.profile else {
				return .success([])
			}
			let groups = await convertGroupFromResponse(groups: data, server: server)
			await channelStorage.realmManager.addAndUpdateGroups(groups: groups)
			return .success(groups)

		case .failure(let error):
			return .failure(error)
		}
	}
	
	public func joinGroup(by groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		let apiService = channelStorage.getChannel(domain: domain)
		guard let clientId = apiService.owner?.id else { return .failure(ServerError.unknown) }
		var request = Group_JoinGroupRequest()
		request.groupID = groupId
		request.clientID = clientId
		
		return await apiService.joinGroup(request)
	}
	
	public func addMember(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		let apiService = channelStorage.currentServer?.profile
		guard let clientId = apiService?.userId,
				let userName = apiService?.userName else { return .failure(ServerError.unknown) }
		var requestAddedMember = Group_MemberInfo()
		requestAddedMember.id = user.id
		requestAddedMember.workspaceDomain = user.workspaceDomain
		requestAddedMember.displayName = user.displayName

		var requestAddingMember = Group_MemberInfo()
		requestAddingMember.id = clientId
		requestAddingMember.workspaceDomain = domain
		requestAddingMember.displayName = userName

		var request = Group_AddMemberRequest()
		request.addingMemberInfo = requestAddingMember
		request.addedMemberInfo = requestAddedMember
		request.groupID = groupId

		return await channelStorage.getChannel(domain: domain).addMember(request)
	}
	
	public func leaveGroup(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		let apiService = channelStorage.currentServer?.profile
		guard let clientId = apiService?.userId,
				let userName = apiService?.userName else { return .failure(ServerError.unknown) }
		var memberInfo = Group_MemberInfo()
		memberInfo.id = user.id
		memberInfo.workspaceDomain = user.workspaceDomain
		memberInfo.displayName = user.displayName

		var memberBy = Group_MemberInfo()
		memberBy.id = clientId
		memberBy.workspaceDomain = domain
		memberBy.displayName = userName

		var request = Group_LeaveGroupRequest()
		request.leaveMember = memberInfo
		request.leaveMemberBy = memberBy
		request.groupID = groupId
		let response = await channelStorage.getChannel(domain: domain).leaveGroup(request)
		
		switch response {
		case .success(let data):
			if clientId == user.id {
				senderStore.deleteSenderKey(groupId: groupId, clientId: clientId, domain: domain)
				channelStorage.realmManager.deleteGroup(groupId: groupId, domain: domain)
			}
			return .success(data)
		case .failure(let error):
			return .failure(error)
		}
	}
}

private extension GroupService {
	func convertGroupFromResponse(groups: Group_GetJoinedGroupsResponse, server: RealmServer) async -> [RealmGroup] {
		return await withCheckedContinuation({ continuation in
			var realmGroups: [RealmGroup] = []
			guard let profile = server.profile else {
				return
			}
			
			groups.lstGroup.forEach { groupResponse in
				let oldGroup = channelStorage.realmManager.getGroup(by: groupResponse.groupID, domain: server.serverDomain, ownerId: profile.userId)
				var isRegisteredKey = oldGroup?.isJoined ?? false
				let lastMessageSyncTime = oldGroup?.lastMessageSyncTimestamp ?? (server.loginTime ?? Int64(Date().timeIntervalSince1970))
				
				if groupResponse.clientKey.senderKey.count != 0 && groupResponse.groupType == "group" && !isRegisteredKey {
					do {
						let identityKey = try signalStore.identityStore.identityKeyPair(context: NullContext())
						let privateKey = identityKey.privateKey
						let pbkdf2 = PBKDF2(passPharse: bytesConvertToHexString(bytes: privateKey.serialize()))
						let senderKeyDecrypted = pbkdf2.decrypt(data: [UInt8](groupResponse.clientKey.senderKey), saltHex: server.salt, ivParameterSpec: server.iv)
						let senderAddress = try ProtocolAddress(name: "\(server.serverDomain)_\(profile.userId)", deviceId: UInt32(Constants.senderDeviceId))
						let senderKeyRecord = try SenderKeyRecord(bytes: Data(senderKeyDecrypted ?? []))
						guard let uuid = senderStore.getSenderDistributionID(senderID: profile.userId, groupId: groupResponse.groupID, isCreateNew: true) else { return }
						try senderStore.storeSenderKey(from: senderAddress, distributionId: uuid, record: senderKeyRecord, context: NullContext())
						isRegisteredKey = true
					} catch {
						print(error)
						return
					}
				}
				
				let realmGroup = RealmGroup()
				let groupMembers = groupResponse.lstClient.map { member -> RealmMember in
					let realmMember = RealmMember()
					realmMember.userId = member.id
					realmMember.userName = member.displayName
					realmMember.domain = member.workspaceDomain
					realmMember.userState = member.status
					realmMember.server = server
					return realmMember
				}
				
				realmGroup.generateId = oldGroup?.generateId ?? UUID().uuidString
				realmGroup.groupId = groupResponse.groupID
				if groupResponse.groupType == "group" {
					realmGroup.groupName = groupResponse.groupName
				} else {
					realmGroup.groupName = groupResponse.lstClient.first { $0.id != profile.userId }?.displayName ?? ""
				}
				realmGroup.groupAvatar = groupResponse.groupAvatar
				realmGroup.groupType = groupResponse.groupType
				realmGroup.createdBy = groupResponse.createdByClientID
				realmGroup.createdAt = groupResponse.createdAt
				realmGroup.updatedBy = groupResponse.updatedByClientID
				realmGroup.updatedAt = groupResponse.updatedAt
				realmGroup.rtcToken = groupResponse.groupRtcToken
				realmGroup.groupMembers.append(objectsIn: groupMembers)
				realmGroup.isJoined = isRegisteredKey
				realmGroup.ownerDomain = server.serverDomain
				realmGroup.ownerClientId = profile.userId
				realmGroup.lastMessage = nil
				realmGroup.lastMessageAt = groupResponse.lastMessageAt
				realmGroup.lastMessageSyncTimestamp = lastMessageSyncTime
				realmGroup.isDeletedUserPeer = false
				realmGroup.hasUnreadMessage = groupResponse.hasUnreadMessage_p
				realmGroup.server = server
				
				realmGroups.append(realmGroup)
				
			}
			continuation.resume(returning: realmGroups)
		})
	}
	
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
