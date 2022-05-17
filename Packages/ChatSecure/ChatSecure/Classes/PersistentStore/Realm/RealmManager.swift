//
//  RealmManager.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift
import Networking

class RealmManager {
	// MARK: - Variables
	private var configuration = Realm.Configuration()
	
	// MARK: - Init
	init(databasePath: URL?) {
		configuration.fileURL = databasePath
	}
}

// MARK: - Message
extension RealmManager {
}

// MARK: - Group
extension RealmManager {
	func addAndUpdateGroups(group: Group_GetJoinedGroupsResponse, domain: String) async -> [RealmGroup] {
		return await withCheckedContinuation({ continuation in
			let dispatchGroup = DispatchGroup()
			
			var realmGroups: [RealmGroup] = []
			
			group.lstGroup.forEach { groupResponse in
				dispatchGroup.enter()
				let server = getServer(by: domain)
				guard let server = server, let profile = server.profile else {
					dispatchGroup.leave()
					return
				}
				let oldGroup = getGroup(by: groupResponse.groupID, domain: domain, ownerId: profile.userId)
				
				let isRegisteredKey = oldGroup?.isJoined ?? false
				let lastMessageSyncTime = oldGroup?.lastMessageSyncTimestamp ?? (server.loginTime ?? Int64(Date().timeIntervalSince1970))
				
				write { realm in
					let realmGroup = RealmGroup()
					let groupMembers = groupResponse.lstClient.map { member -> RealmMember in
						let realmMember = RealmMember()
						realmMember.userId = member.id
						realmMember.userName = member.displayName
						realmMember.domain = member.workspaceDomain
						realmMember.userState = member.status
						return realmMember
					}
					realmGroup.generateId = oldGroup?.generateId ?? (realm.objects(RealmGroup.self).max(ofProperty: "generateId") ?? 0) + 1
					realmGroup.groupId = groupResponse.groupID
					realmGroup.groupName = groupResponse.groupName
					realmGroup.groupAvatar = groupResponse.groupAvatar
					realmGroup.groupType = groupResponse.groupType
					realmGroup.createdBy = groupResponse.createdByClientID
					realmGroup.createdAt = groupResponse.createdAt
					realmGroup.updatedBy = groupResponse.updatedByClientID
					realmGroup.updatedAt = groupResponse.updatedAt
					realmGroup.rtcToken = groupResponse.groupRtcToken
					realmGroup.groupMembers = groupMembers
					realmGroup.isJoined = isRegisteredKey
					realmGroup.ownerDomain = domain
					realmGroup.ownerClientId = profile.userId
					realmGroup.lastMessage = nil
					realmGroup.lastMessageAt = groupResponse.lastMessageAt
					realmGroup.lastMessageSyncTimestamp = lastMessageSyncTime
					realmGroup.isDeletedUserPeer = false
					realmGroup.hasUnreadMessage = groupResponse.hasUnreadMessage_p
					
					realm.add(realmGroup, update: .modified)
					realmGroups.append(realmGroup)
					dispatchGroup.leave()
				}
			}
			
			dispatchGroup.notify(queue: .main) {
				continuation.resume(returning: realmGroups)
			}
		})
	}
	
	func getGroup(by groupId: Int64, domain: String, ownerId: String) -> RealmGroup? {
		let groups = load(listOf: RealmGroup.self, filter: NSPredicate(format: "groupId == %ld && ownerDomain == %@ && ownerClientId == %@", groupId, domain, ownerId))
		return groups.first
	}
}

// MARK: - Server
extension RealmManager {
	func saveServer(profileResponse: User_UserProfileResponse, authenResponse: Auth_AuthRes) {
		let oldServer = getServer(by: authenResponse.workspaceDomain)
		
		write { realm in
			let realmServer = RealmServer()
			realmServer.generateId = oldServer?.generateId ?? (realm.objects(RealmServer.self).max(ofProperty: "generateId") ?? 0) + 1
			realmServer.serverName = authenResponse.workspaceName
			realmServer.serverDomain = authenResponse.workspaceDomain
			realmServer.ownerClientId = profileResponse.id
			realmServer.serverAvatar = ""
			realmServer.loginTime = Int64(Date().timeIntervalSince1970)
			realmServer.accessKey = authenResponse.accessToken
			realmServer.hashKey = authenResponse.hashKey
			realmServer.refreshToken = authenResponse.refreshToken
			realmServer.isActive = true
			
			let profile = RealmProfile()
			profile.userId = profileResponse.id
			profile.userName = profileResponse.displayName
			profile.email = profileResponse.email
			profile.phoneNumber = profileResponse.phoneNumber
			profile.updatedAt = Int64(Date().timeIntervalSince1970)
			profile.avatar = profileResponse.avatar
			
			realmServer.profile = profile
			
			realm.add(realmServer, update: .modified)
		}
	}
	
	func getServer(by domain: String) -> RealmServer? {
		let servers = load(listOf: RealmServer.self, filter: NSPredicate(format: "serverDomain == %@", domain))
		return servers.first
	}
	
	func getServers() -> [RealmServer] {
		let servers = load(listOf: RealmServer.self)
		return servers
	}
}

// MARK: - Private
private extension RealmManager {
	private func write(_ handler: ((_ realm: Realm) -> Void)) {
		do {
			let realm = try Realm(configuration: configuration)
			try realm.write {
				handler(realm)
			}
		} catch {
			print(error)
		}
	}
	
	private func load<T: Object>(listOf: T.Type, filter: NSPredicate? = nil) -> [T] {
		do {
			var objects = try Realm(configuration: configuration).objects(T.self)
			if let filter = filter {
				objects = objects.filter(filter)
			}
			var list = [T]()
			for obj in objects {
				list.append(obj)
			}
			return list
		} catch {
			print(error)
		}
		return []
	}
	
	func removeAll() {
		write { realm in
			realm.deleteAll()
		}
	}
}
