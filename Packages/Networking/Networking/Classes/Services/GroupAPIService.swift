//
//  GroupAPIService.swift
//  Networking
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Combine

public protocol IGroupAPIService {
	func createGroup(_ request: Group_CreateGroupRequest) async -> (Result<Group_GroupObjectResponse, Error>)
	func searchGroups(_ request: Group_SearchGroupsRequest) async -> (Result<Group_SearchGroupsResponse, Error>)
	func getGroup(_ request: Group_GetGroupRequest) async -> (Result<Group_GroupObjectResponse, Error>)
	func getJoinedGroups(_ request: Group_GetJoinedGroupsRequest) async -> (Result<Group_GetJoinedGroupsResponse, Error>)
	func joinGroup(_ request: Group_JoinGroupRequest) async -> (Result<Group_BaseResponse, Error>)
	func addMember(_ request: Group_AddMemberRequest) async -> (Result<Group_BaseResponse, Error>)
	func leaveGroup(_ request: Group_LeaveGroupRequest) async -> (Result<Group_BaseResponse, Error>)
}

extension APIService: IGroupAPIService {
	public func createGroup(_ request: Group_CreateGroupRequest) async -> (Result<Group_GroupObjectResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.create_group(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func searchGroups(_ request: Group_SearchGroupsRequest) async -> (Result<Group_SearchGroupsResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.search_groups(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func getGroup(_ request: Group_GetGroupRequest) async -> (Result<Group_GroupObjectResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.get_group(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func getJoinedGroups(_ request: Group_GetJoinedGroupsRequest) async -> (Result<Group_GetJoinedGroupsResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.get_joined_groups(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func joinGroup(_ request: Group_JoinGroupRequest) async -> (Result<Group_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.join_group(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func addMember(_ request: Group_AddMemberRequest) async -> (Result<Group_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.add_member(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
	
	public func leaveGroup(_ request: Group_LeaveGroupRequest) async -> (Result<Group_BaseResponse, Error>) {
		return await withCheckedContinuation({ continuation in
			let caller = clientGroup.leave_group(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
							continuation.resume(returning: result)
						}
					} else {
						continuation.resume(returning: .failure(ServerError(status)))
					}
				case .failure(let error):
					continuation.resume(returning: .failure(ServerError(error)))
				}
			})
		})
	}
}
