//
//  GroupService.swift
//  ChatSecure
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Networking

protocol IGroupService {
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [Group_ClientInGroupObject], domain: String) async -> (Result<Group_GroupObjectResponse, Error>)
	func searchGroups(_ keyword: String, domain: String) async -> (Result<Group_SearchGroupsResponse, Error>)
	func getGroup(by groupId: Int64, domain: String) async -> (Result<Group_GroupObjectResponse, Error>)
	func getJoinedGroups(domain: String) async -> (Result<Group_GetJoinedGroupsResponse, Error>)
	func joinGroup(by groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>)
	func addMember(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>)
	func leaveGroup(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>)
}

class GroupService {
	var clientStore: ClientStore
	
	public init() {
		clientStore = ClientStore()
	}
}

extension GroupService: IGroupService {
	func createGroup(by clientId: String, groupName: String, groupType: String, lstClient: [Group_ClientInGroupObject], domain: String) async -> (Result<Group_GroupObjectResponse, Error>) {
		var request = Group_CreateGroupRequest()
		request.groupName = groupName
		request.groupType = groupType
		request.lstClient = lstClient
		request.createdByClientID = clientId
		
		return await channelStorage.getChannels(domain: domain).createGroup(request)
	}
	
	func searchGroups(_ keyword: String, domain: String) async -> (Result<Group_SearchGroupsResponse, Error>) {
		var request = Group_SearchGroupsRequest()
		request.keyword = keyword
		
		return await channelStorage.getChannels(domain: domain).searchGroups(request)
	}
	
	func getGroup(by groupId: Int64, domain: String) async -> (Result<Group_GroupObjectResponse, Error>) {
		var request = Group_GetGroupRequest()
		request.groupID = groupId
		
		return await channelStorage.getChannels(domain: domain).getGroup(request)
	}
	
	func getJoinedGroups(domain: String) async -> (Result<Group_GetJoinedGroupsResponse, Error>) {
		let request = Group_GetJoinedGroupsRequest()
		
		return await channelStorage.getChannels(domain: domain).getJoinedGroups(request)
	}
	
	func joinGroup(by groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		let apiService = channelStorage.getChannels(domain: domain)
		guard let clientId = apiService.owner?.id else { return .failure(ServerError.unknown) }
		var request = Group_JoinGroupRequest()
		request.groupID = groupId
		request.clientID = clientId
		
		return await apiService.joinGroup(request)
	}
	
	func addMember(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		let apiService = channelStorage.getChannels(domain: domain)
		guard let clientId = apiService.owner?.id,
			  let userName = apiService.owner?.name else { return .failure(ServerError.unknown) }
		var requestAddingMember = Group_MemberInfo()
		requestAddingMember.id = user.id
		requestAddingMember.workspaceDomain = user.workspaceDomain
		requestAddingMember.displayName = user.displayName
		requestAddingMember.status = ""
		
		var requestAddedMember = Group_MemberInfo()
		requestAddingMember.id = clientId
		requestAddingMember.workspaceDomain = domain
		requestAddingMember.displayName = userName
		requestAddingMember.status = ""
		
		var request = Group_AddMemberRequest()
		request.addingMemberInfo = requestAddingMember
		request.addedMemberInfo = requestAddedMember
		request.groupID = groupId
		
		return await apiService.addMember(request)
	}
	
	func leaveGroup(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		var memberInfo = Group_MemberInfo()
		memberInfo.id = user.id
		memberInfo.workspaceDomain = user.workspaceDomain
		memberInfo.displayName = user.displayName
		memberInfo.status = ""
		
		var request = Group_LeaveGroupRequest()
		request.leaveMember = memberInfo
		request.leaveMemberBy = memberInfo
		request.groupID = groupId
		
		return await channelStorage.getChannels(domain: domain).leaveGroup(request)
	}
}
