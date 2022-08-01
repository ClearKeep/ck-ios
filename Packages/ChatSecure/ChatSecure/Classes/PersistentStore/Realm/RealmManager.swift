//
//  RealmManager.swift
//  ChatSecure
//
//  Created by NamNH on 11/05/2022.
//

import Foundation
import RealmSwift
import Networking
import Model

public class RealmManager {
	// MARK: - Variables
	private var configuration = Realm.Configuration()
	private var backgroundQueue = DispatchQueue(label: "realm.queue",
												qos: .background,
												target: nil)
	
	// MARK: - Init
	public init(databasePath: URL?) {
		configuration.fileURL = databasePath
	}
}

// MARK: - Message
extension RealmManager {
	func saveMessages(messages: [RealmMessage]) {
		write { realm in
			realm.add(messages, update: .modified)
		}
	}
	
	func saveMessage(message: RealmMessage) {
		write { realm in
			realm.add(message, update: .modified)
		}
	}
	
	public func getMessages(groupId: Int64, ownerDomain: String, ownerId: String) -> Results<RealmMessage>? {
		do {
			let realm = try Realm(configuration: self.configuration)
			let predicate = NSPredicate(format: "groupId == %ld && ownerDomain == %@ && ownerClientId == %@", groupId, ownerDomain, ownerId)
			let messages = realm.objects(RealmMessage.self).filter(predicate).sorted(byKeyPath: "createdTime", ascending: false)
			return messages
		} catch {
			return nil
		}
	}
	
	func getMessage(messageId: String) -> RealmMessage? {
		let message = load(ofType: RealmMessage.self, primaryKey: messageId)
		return message
	}
	
	func deleteMessagesFromGroup(groupId: Int64, ownerDomain: String, ownerId: String) {
		delete(listOf: RealmMessage.self, filter: NSPredicate(format: "groupId == %ld && ownerDomain == %@ && ownerClientId == %@", groupId, ownerDomain, ownerId))
	}
	
	func deleteMessagesByDomain(domain: String, ownerId: String) {
		delete(listOf: RealmMessage.self, filter: NSPredicate(format: "ownerDomain == %@ && ownerClientId == %@", domain, ownerId))
	}
}

// MARK: - Group
extension RealmManager {
	func addAndUpdateGroups(group: Group_GetJoinedGroupsResponse, domain: String) async -> [RealmGroup] {
		return await withCheckedContinuation({ continuation in
			var realmGroups: [RealmGroup] = []
			
			group.lstGroup.forEach { groupResponse in
				let server = getServer(by: domain)
				guard let server = server, let profile = server.profile else {
					return
				}
				let oldGroup = getGroup(by: groupResponse.groupID, domain: domain, ownerId: profile.userId)
				
				let isRegisteredKey = oldGroup?.isJoined ?? false
				let lastMessageSyncTime = oldGroup?.lastMessageSyncTimestamp ?? (server.loginTime ?? Int64(Date().timeIntervalSince1970))
				
				let realmGroup = RealmGroup()
				let groupMembers = groupResponse.lstClient.map { member -> RealmMember in
					let realmMember = RealmMember()
					realmMember.userId = member.id
					realmMember.userName = member.displayName
					realmMember.domain = member.workspaceDomain
					realmMember.userState = member.status
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
				realmGroup.ownerDomain = domain
				realmGroup.ownerClientId = profile.userId
				realmGroup.lastMessage = nil
				realmGroup.lastMessageAt = groupResponse.lastMessageAt
				realmGroup.lastMessageSyncTimestamp = lastMessageSyncTime
				realmGroup.isDeletedUserPeer = false
				realmGroup.hasUnreadMessage = groupResponse.hasUnreadMessage_p
				
				realmGroups.append(realmGroup)
			}
			write { realm in
				realm.add(realmGroups, update: .modified)
			}
			continuation.resume(returning: realmGroups)
		})
	}
	
	func addAndUpdateGroup(group: Group_GroupObjectResponse, domain: String) async -> RealmGroup {
		return await withCheckedContinuation({ continuation in
			
				let server = getServer(by: domain)
				guard let server = server, let profile = server.profile else {
					return
				}
				let oldGroup = getGroup(by: group.groupID, domain: domain, ownerId: profile.userId)
				
				let isRegisteredKey = oldGroup?.isJoined ?? false
				let lastMessageSyncTime = oldGroup?.lastMessageSyncTimestamp ?? (server.loginTime ?? Int64(Date().timeIntervalSince1970))
				
				let realmGroup = RealmGroup()
				let groupMembers = group.lstClient.map { member -> RealmMember in
					let realmMember = RealmMember()
					realmMember.userId = member.id
					realmMember.userName = member.displayName
					realmMember.domain = member.workspaceDomain
					realmMember.userState = member.status
					return realmMember
				}
				
				realmGroup.generateId = oldGroup?.generateId ?? UUID().uuidString
				realmGroup.groupId = group.groupID
				if group.groupType == "group" {
					realmGroup.groupName = group.groupName
				} else {
					realmGroup.groupName = group.lstClient.first { $0.id != profile.userId }?.displayName ?? ""
				}
				realmGroup.groupAvatar = group.groupAvatar
				realmGroup.groupType = group.groupType
				realmGroup.createdBy = group.createdByClientID
				realmGroup.createdAt = group.createdAt
				realmGroup.updatedBy = group.updatedByClientID
				realmGroup.updatedAt = group.updatedAt
				realmGroup.rtcToken = group.groupRtcToken
			    realmGroup.groupMembers.append(objectsIn: groupMembers)
				realmGroup.isJoined = isRegisteredKey
				realmGroup.ownerDomain = domain
				realmGroup.ownerClientId = profile.userId
				realmGroup.lastMessage = nil
				realmGroup.lastMessageAt = group.lastMessageAt
				realmGroup.lastMessageSyncTimestamp = lastMessageSyncTime
				realmGroup.isDeletedUserPeer = false
				realmGroup.hasUnreadMessage = group.hasUnreadMessage_p
							
			write { realm in
				realm.add(realmGroup, update: .modified)
			}
			continuation.resume(returning: realmGroup)
		})
	}
	
	func getGroup(by groupId: Int64, domain: String, ownerId: String) -> RealmGroup? {
		let groups = load(listOf: RealmGroup.self, filter: NSPredicate(format: "groupId == %ld && ownerDomain == %@ && ownerClientId == %@", groupId, domain, ownerId))
		return groups.first
	}
	
	public func getJoinedGroup(ownerId: String, domain: String) -> [RealmGroup] {
		let groups = load(listOf: RealmGroup.self, filter: NSPredicate(format: "ownerDomain == %@ && ownerClientId == %@", domain, ownerId))
		return groups
	}
}

// MARK: - Server
extension RealmManager {
	func saveServer(profileResponse: User_UserProfileResponse, authenResponse: Auth_AuthRes, isSocialAccount: Bool) {
		let oldServer = getServer(by: authenResponse.workspaceDomain)
		
		deactiveAllServer { [weak self] realm in
			guard let self = self else { return }
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
			profile.isSocialAccount = isSocialAccount
			
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
	
	func getCurrentServer() -> RealmServer? {
		let servers = load(listOf: RealmServer.self, filter: NSPredicate(format: "isActive == true"))
		return servers.first
	}

	func removeServer(domain: String) {
		delete(listOf: RealmServer.self, filter: NSPredicate(format: "serverDomain == %@", domain))
	}
	
	func deactiveAllServer(completion: @escaping (_ realm: Realm) -> Void) {
		write { realm in
			let servers = self.load(listOf: RealmServer.self, filter: NSPredicate(format: "isActive == true"))
			servers.forEach { oldServer in
				oldServer.isActive = false
			}
			
			realm.add(servers, update: .modified)
			completion(realm)
		}
	}
	
	func activeServer(domain: String?) -> [RealmServer] {
		guard let domain = domain else {
			deactiveAllServer { _ in }
			return getServers()
		}

		guard let server = self.getServer(by: domain) else { return getServers() }
		deactiveAllServer { [weak self] realm in
			guard let self = self else { return }
			
			server.isActive = true
			realm.add(server, update: .modified)
		}
		return getServers()
	}
}

extension RealmManager {
	public func getOwnerServer(domain: String) -> IUser? {
		struct User: IUser {
			var id: String
			var displayName: String
			var email: String
			var phoneNumber: String
			var avatar: String
			var status: String

			init(profile: RealmProfile?) {
				self.id = profile?.userId ?? ""
				self.displayName = profile?.userName ?? ""
				self.avatar = profile?.avatar ?? ""
				self.email = profile?.email ?? ""
				self.status = ""
				self.phoneNumber = profile?.phoneNumber ?? ""
			}
		}

		let servers = load(listOf: RealmServer.self, filter: NSPredicate(format: "%K == %@", #keyPath(RealmServer.serverDomain), domain))
		let server = servers.first
		return User(profile: server?.profile)
	}
}

// MARK: - Private
private extension RealmManager {
	private func write(_ handler: @escaping ((_ realm: Realm) -> Void)) {
		do {
			let realm = try Realm(configuration: self.configuration)
			try realm.write {
				handler(realm)
			}
		} catch {
			print(error)
		}
	}
	
	private func load<T: Object>(listOf: T.Type, filter: NSPredicate? = nil, sortKeyPath: String? = nil) -> [T] {
		do {
			var objects = try Realm(configuration: configuration).objects(T.self)
			if let filter = filter {
				objects = objects.filter(filter)
			}
			if let sortKeyPath = sortKeyPath {
				objects = objects.sorted(byKeyPath: sortKeyPath)
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
	
	private func load<T: Object>(ofType: T.Type, primaryKey: String) -> T? {
		do {
			let object = try Realm(configuration: configuration).object(ofType: T.self, forPrimaryKey: primaryKey)
			return object
		} catch {
			return nil
		}
	}
	
	private func delete<T: Object>(listOf: T.Type, filter: NSPredicate? = nil) {
		do {
			let realm = try Realm(configuration: self.configuration)
			try realm.write({
				var objects = realm.objects(T.self)
				if let filter = filter {
					objects = objects.filter(filter)
				}
				realm.delete(objects)
			})
		} catch {
			print(error)
		}
	}
	
	func removeAll() {
		write { realm in
			realm.deleteAll()
		}
	}
}
