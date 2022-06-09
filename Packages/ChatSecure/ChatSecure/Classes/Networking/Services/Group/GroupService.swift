//
//  GroupService.swift
//  ChatSecure
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Networking

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
	public init() {
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
			print(data)
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
			return await .success(channelStorage.realmManager.addAndUpdateGroups(group: data, domain: domain))
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
		let apiService = channelStorage.getChannel(domain: domain)
		guard let clientId = apiService.owner?.id,
			  let userName = apiService.owner?.displayName else { return .failure(ServerError.unknown) }
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
	
	public func leaveGroup(_ user: Group_ClientInGroupObject, groupId: Int64, domain: String) async -> (Result<Group_BaseResponse, Error>) {
		var memberInfo = Group_MemberInfo()
		memberInfo.id = user.id
		memberInfo.workspaceDomain = user.workspaceDomain
		memberInfo.displayName = user.displayName
		memberInfo.status = ""
		
		var request = Group_LeaveGroupRequest()
		request.leaveMember = memberInfo
		request.leaveMemberBy = memberInfo
		request.groupID = groupId
		
		return await channelStorage.getChannel(domain: domain).leaveGroup(request)
	}
}
