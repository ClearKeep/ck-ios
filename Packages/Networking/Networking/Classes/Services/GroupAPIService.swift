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
			let status = clientGroup.create_group(request).status
			let response = clientGroup.create_group(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
			let status = clientGroup.search_groups(request).status
			let response = clientGroup.search_groups(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
			let status = clientGroup.get_group(request).status
			let response = clientGroup.get_group(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
			let status = clientGroup.get_joined_groups(request).status
			let response = clientGroup.get_joined_groups(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
			let status = clientGroup.join_group(request).status
			let response = clientGroup.join_group(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
			let status = clientGroup.add_member(request).status
			let response = clientGroup.add_member(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
			let status = clientGroup.leave_group(request).status
			let response = clientGroup.leave_group(request).response
			
			status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						response.whenComplete { result in
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
