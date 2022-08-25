//
//  MessageService.swift
//  ChatSecure
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Networking
import Common
import SignalServiceKit
import LibSignalClient
import SwiftSRP
// swiftlint:disable function_body_length
public protocol IMessageService {
	var currentRoomId: Int64 { get set }
	
	func updateCurrentRoom(roomId: Int64)
	
	func sendMessageInPeer(senderId: String,
						   ownerDomain: String,
						   receiverId: String,
						   receiverDomain: String,
						   groupId: Int64,
						   plainMessage: String,
						   isForceProcessKey: Bool,
						   cachedMessageId: Int) async -> Result<RealmMessage, Error>
	
	func sendMessageInGroup(senderId: String,
							ownerWorkspace: String,
							groupId: Int64,
							isJoined: Bool,
							plainMessage: String,
							cachedMessageId: Int,
							isForward: Bool) async -> Result<RealmMessage, Error>
	
	func getMessage(ownerDomain: String,
					ownerId: String,
					groupId: Int64,
					loadSize: Int,
					isGroup: Bool,
					lastMessageAt: Int64) async -> Result<[RealmMessage], Error>
	
	func decryptPeerMessage(senderName: String, message: Data, messageId: String) -> String?
	func decryptGroupMessage(senderId: String, senderDomain: String, ownerId: String, ownerDomain: String, groupID: Int64, message: Data) async -> String?
	
}

public class MessageService {
	private let clientStore: ClientStore
	private let signalStore: ISignalProtocolInMemoryStore
	private let senderStore: ISenderKeyStore
		
	public init(clientStore: ClientStore, signalStore: ISignalProtocolInMemoryStore, senderStore: ISenderKeyStore) {
		self.clientStore = clientStore
		self.signalStore = signalStore
		self.senderStore = senderStore
	}
	
	public var currentRoomId: Int64 = 0
}

extension MessageService: IMessageService {
	
	public func updateCurrentRoom(roomId: Int64) {
		self.currentRoomId = roomId
	}
	
	public func sendMessageInPeer(senderId: String, ownerDomain: String, receiverId: String, receiverDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<RealmMessage, Error> {
		channelStorage.updateTempServer(server: TempServer(serverDomain: ownerDomain, ownerClientId: senderId))
		Debug.DLog("sendMessageInPeer: receivcerId: \(receiverId), groupID: \(groupId)")
		do {
			let receiverAddress = try ProtocolAddress(name: "\(receiverDomain)_\(receiverId)", deviceId: UInt32(Constants.senderDeviceId))
			
			let existingSession = try signalStore.sessionStore.loadSession(for: receiverAddress, context: NullContext())
			
			if existingSession == nil || isForceProcessKey {
				let isSuccess = await requestKeyPeer(senderId: senderId, senderDomain: ownerDomain, receiverId: receiverId, receiverDomain: receiverDomain)
				if !isSuccess {
					Debug.DLog("Send message in peer fail - Can't request key peer")
					return .failure(ServerError.unknown)
				}
			}
			
			guard let messageData = plainMessage.data(using: .utf8) else {
				return .failure(ServerError.unknown)
			}
			
			let message = try signalEncrypt(
				message: messageData,
				for: receiverAddress,
				sessionStore: signalStore.sessionStore,
				identityStore: signalStore.identityStore,
				context: NullContext())
			let messageSender = try signalEncrypt(
				message: messageData,
				for: ProtocolAddress(name: "\(ownerDomain)_\(senderId)", deviceId: UInt32(Constants.senderDeviceId)),
				sessionStore: signalStore.sessionStore,
				identityStore: signalStore.identityStore,
				context: NullContext())
			
			var request = Message_PublishRequest()
			request.clientID = receiverId
			request.fromClientDeviceID = clientStore.getUniqueDeviceId()
			request.groupID = groupId
			request.message = Data(message.serialize())
			request.senderMessage = Data(messageSender.serialize())
			
			let response = await channelStorage.getChannel(domain: ownerDomain).sendMessage(request)
			switch response {
			case .success(let messageRespone):
				let realmMessage = RealmMessage()
				realmMessage.ownerDomain = ownerDomain
				realmMessage.createdTime = messageRespone.createdAt
				realmMessage.groupId = messageRespone.groupID
				realmMessage.receiverId = messageRespone.clientID
				realmMessage.groupType = messageRespone.groupType
				realmMessage.senderId = messageRespone.fromClientID
				realmMessage.messageId = messageRespone.id
				realmMessage.updatedTime = messageRespone.updatedAt
				realmMessage.ownerClientId = senderId
				realmMessage.message = plainMessage
				channelStorage.realmManager.saveMessage(message: realmMessage)
				return .success(realmMessage)
			case .failure(let error):
				Debug.DLog("Send message in peer fail - \(error)")
				return .failure(ServerError(error))
			}
		} catch {
			Debug.DLog("Send message in peer fail - Can't encrypt message")
			return .failure(ServerError.unknown)
		}
	}
	
	public func sendMessageInGroup(senderId: String, ownerWorkspace: String, groupId: Int64, isJoined: Bool, plainMessage: String, cachedMessageId: Int, isForward: Bool) async -> Result<RealmMessage, Error> {
		channelStorage.updateTempServer(server: TempServer(serverDomain: ownerWorkspace, ownerClientId: senderId))
		if isJoined {
			return await sendGroupMessage(senderId: senderId, ownerWorkspace: ownerWorkspace, groupId: groupId, plainMessage: plainMessage, cachedMessageId: cachedMessageId, isForward: isForward)
		} else {
			let result = await registerSenderKeyToGroup(groupID: groupId, clientId: senderId, domain: ownerWorkspace)
			if result {
				return await sendGroupMessage(senderId: senderId, ownerWorkspace: ownerWorkspace, groupId: groupId, plainMessage: plainMessage, cachedMessageId: cachedMessageId, isForward: isForward)
			} else {
				Debug.DLog("Send group message fail - cannot register key")
				return .failure(ServerError.unknown)
			}
		}
	}
	
	public func getMessage(ownerDomain: String, ownerId: String, groupId: Int64, loadSize: Int, isGroup: Bool, lastMessageAt: Int64) async -> Result<[RealmMessage], Error> {
		channelStorage.updateTempServer(server: TempServer(serverDomain: ownerDomain, ownerClientId: ownerId))
		var request = Message_GetMessagesInGroupRequest()
		request.groupID = groupId
		request.lastMessageAt = lastMessageAt
		request.offSet = Int32(loadSize)
		
		let response = await channelStorage.getChannel(domain: ownerDomain).getMessage(request)
		switch response {
		case .success(let messageRespone):
			print(messageRespone)
			var realmMessages = [RealmMessage]()
			if messageRespone.lstMessage.count == 0 {
				return .success(realmMessages)
			}
			
			await messageRespone.lstMessage.asyncForEach({ message in
				var decryptedMessage = ""
				if let oldMessage = channelStorage.realmManager.getMessage(messageId: message.id) {
					decryptedMessage = oldMessage.message
				} else {
					if isGroup {
						decryptedMessage = await decryptGroupMessage(senderId: message.fromClientID, senderDomain: message.fromClientWorkspaceDomain, ownerId: ownerId, ownerDomain: ownerDomain, groupID: groupId, message: message.message) ?? ""
					} else {
						if message.fromClientID == ownerId {
							decryptedMessage = decryptPeerMessage(senderName: "\(ownerDomain)_\(ownerId)", message: message.senderMessage, messageId: message.id) ?? ""
						} else {
							decryptedMessage = decryptPeerMessage(senderName: "\(message.fromClientWorkspaceDomain)_\(message.fromClientID)", message: message.message, messageId: message.id) ?? ""
						}
					}
				}
				let realmMessage = RealmMessage()
				realmMessage.ownerDomain = ownerDomain
				realmMessage.createdTime = message.createdAt
				realmMessage.groupId = message.groupID
				realmMessage.receiverId = message.clientID
				realmMessage.groupType = message.groupType
				realmMessage.senderId = message.fromClientID
				realmMessage.messageId = message.id
				realmMessage.updatedTime = message.updatedAt
				realmMessage.ownerClientId = ownerId
				realmMessage.message = decryptedMessage
				realmMessages.append(realmMessage)
			})
			if !realmMessages.isEmpty {
				channelStorage.realmManager.saveMessages(messages: realmMessages)
			}
			return .success(realmMessages)
		case .failure(let error):
			Debug.DLog("Get message fail - \(error)")
			return .failure(ServerError(error))
		}
	}
}

private extension MessageService {
	func requestKeyPeer(senderId: String, senderDomain: String, receiverId: String, receiverDomain: String) async -> Bool {
		await initSessionUserPeer(byClientId: senderId, workspaceDomain: senderDomain)
		return await initSessionUserPeer(byClientId: receiverId, workspaceDomain: receiverDomain)
	}
	
	@discardableResult
	func initSessionUserPeer(byClientId clientId: String, workspaceDomain: String) async -> Bool {
		Debug.DLog("initSessionUserPeer with \(clientId), domain = \(workspaceDomain)")
		var request = Signal_PeerGetClientKeyRequest()
		request.clientID = clientId
		request.workspaceDomain = workspaceDomain
		let response = await channelStorage.getChannel(domain: workspaceDomain).peerGetClientKey(request)
		
		switch response {
		case .success(let recipientResponse):
			do {
				let preKey = try PreKeyRecord(bytes: recipientResponse.preKey)
				let signedPreKey = try SignedPreKeyRecord(bytes: recipientResponse.signedPreKey)
				let identityKeyPublic = try IdentityKey(bytes: recipientResponse.identityKeyPublic)
				
				let retrievedPreKeyBundle = try PreKeyBundle(
					registrationId: UInt32(bitPattern: recipientResponse.registrationID),
					deviceId: UInt32(bitPattern: recipientResponse.deviceID),
					prekeyId: preKey.id,
					prekey: preKey.publicKey,
					signedPrekeyId: UInt32(bitPattern: recipientResponse.signedPreKeyID),
					signedPrekey: signedPreKey.publicKey,
					signedPrekeySignature: signedPreKey.signature,
					identity: identityKeyPublic
				)
				let addressName = "\(workspaceDomain)_\(clientId)"
				let address = try ProtocolAddress(name: addressName, deviceId: UInt32(Constants.senderDeviceId))
				try processPreKeyBundle(
					retrievedPreKeyBundle,
					for: address,
					sessionStore: signalStore.sessionStore,
					identityStore: signalStore.identityStore,
					context: NullContext())
				Debug.DLog("initSessionUserPeer: success")
				return true
			} catch {
				Debug.DLog("initSessionUserPeer processPreKeyBundle fail with exception: \(error)")
				return false
			}
		case .failure(let error):
			Debug.DLog("initSessionUserPeer GetClientKey fail with exception: \(error)")
			return false
		}
	}
	
	func sendGroupMessage(senderId: String, ownerWorkspace: String, groupId: Int64, plainMessage: String, cachedMessageId: Int, isForward: Bool) async -> Result<RealmMessage, Error> {
		do {
			let senderAddress = try ProtocolAddress(name: "\(ownerWorkspace)_\(senderId)", deviceId: UInt32(Constants.senderDeviceId))
			guard let messageData = plainMessage.data(using: .utf8) else {
				Debug.DLog("Send message fail - cannot decode message")
				return .failure(ServerError.unknown)
			}
			guard let distributionId = senderStore.getSenderDistributionID(senderID: senderId, groupId: groupId, isCreateNew: false) else {
				Debug.DLog("Send message fail - cannot get sender distribution")
				return .failure(ServerError.unknown)
			}
			let ciphertext = try groupEncrypt(messageData, from: senderAddress, distributionId: distributionId, store: senderStore, context: NullContext())
			
			var request = Message_PublishRequest()
			request.clientID = senderId
			request.fromClientDeviceID = clientStore.getUniqueDeviceId()
			request.groupID = groupId
			request.message = Data(ciphertext.serialize())
			request.senderMessage = Data(ciphertext.serialize())
			let response = await channelStorage.getChannel(domain: ownerWorkspace).sendMessage(request)
			switch response {
			case .success(let messageRespone):
				let realmMessage = RealmMessage()
				if isForward {
					return .success(realmMessage)
				}
				realmMessage.ownerDomain = ownerWorkspace
				realmMessage.createdTime = messageRespone.createdAt
				realmMessage.groupId = messageRespone.groupID
				realmMessage.receiverId = messageRespone.clientID
				realmMessage.groupType = messageRespone.groupType
				realmMessage.senderId = messageRespone.fromClientID
				realmMessage.messageId = messageRespone.id
				realmMessage.updatedTime = messageRespone.updatedAt
				realmMessage.ownerClientId = senderId
				realmMessage.message = plainMessage
				channelStorage.realmManager.saveMessage(message: realmMessage)
				return .success(realmMessage)
			case .failure(let error):
				Debug.DLog("Send message fail - \(error.localizedDescription)")
				return .failure(ServerError(error))
			}
		} catch {
			Debug.DLog("Send message fail - Can't encrypt message", error)
			return .failure(ServerError.unknown)
		}
	}
	
	func registerSenderKeyToGroup(groupID: Int64, clientId: String, domain: String) async -> Bool {
		do {
			guard let server = channelStorage.currentServer else { return false }
			let identityKey = try signalStore.identityStore.identityKeyPair(context: NullContext())
			let privateKey = identityKey.privateKey
			
			let senderAddress = try ProtocolAddress(name: "\(domain)_\(clientId)", deviceId: UInt32(Constants.senderDeviceId))
			guard let distributionId = senderStore.getSenderDistributionID(senderID: clientId, groupId: groupID, isCreateNew: true) else { return false }
			let sentAliceDistributionMessage = try SenderKeyDistributionMessage(from: senderAddress, distributionId: distributionId, store: senderStore, context: NullContext())
			let pbkdf2 = PBKDF2(passPharse: bytesConvertToHexString(bytes: privateKey.serialize()))
			
			guard let senderKey = try senderStore.loadSenderKey(from: senderAddress, distributionId: distributionId, context: NullContext()) else { return false }
			let encryptedSenderKey = pbkdf2.encrypt(data: senderKey.serialize(), saltHex: server.salt)
			
			var request = Signal_GroupRegisterClientKeyRequest()
			request.groupID = groupID
			request.deviceID = Int32(Constants.senderDeviceId)
			request.clientKeyDistribution = Data(sentAliceDistributionMessage.serialize())
			request.senderKey = Data(encryptedSenderKey ?? [])
			
			let response = await channelStorage.getChannel(domain: domain).groupRegisterClientKey(request)
			switch response {
			case .success(let result):
				channelStorage.realmManager.updateGroupJoinedStatus(groupId: groupID, domain: domain, ownerId: clientId)
				return true
			case .failure(let error):
				print(error)
				return false
			}
		} catch {
			print(error)
			return false
		}
	}
	
	public func decryptPeerMessage(senderName: String, message: Data, messageId: String) -> String? {
		do {
			let signalProtocolAddress = try ProtocolAddress(name: senderName, deviceId: UInt32(Constants.receiverDeviceId))
			let preKeyMessage = try PreKeySignalMessage(bytes: message)
			let decryptMessage = try signalDecryptPreKey(
				message: preKeyMessage,
				from: signalProtocolAddress,
				sessionStore: signalStore.sessionStore,
				identityStore: signalStore.identityStore,
				preKeyStore: signalStore.preKeyStore,
				signedPreKeyStore: signalStore.signedPreKeyStore,
				context: NullContext())
			return String(bytes: decryptMessage, encoding: .utf8)
		} catch SignalError.duplicatedMessage {
			Debug.DLog("decrypt peer message fail: Duplicate message")
			if let oldMessage = channelStorage.realmManager.getMessage(messageId: messageId) {
				return oldMessage.message
			} else {
				return nil
			}
		} catch {
			Debug.DLog("decrypt peer message fail: \(error)")
			return nil
		}
	}
	
	public func decryptGroupMessage(senderId: String, senderDomain: String, ownerId: String, ownerDomain: String, groupID: Int64, message: Data) async -> String? {
		do {
			let senderAddress: ProtocolAddress
			let distributionId: UUID?
			if senderId == ownerId {
				senderAddress = try ProtocolAddress(name: "\(senderDomain)_\(senderId)", deviceId: UInt32(Constants.senderDeviceId))
				distributionId = senderStore.getSenderDistributionID(senderID: senderId, groupId: groupID, isCreateNew: false)
			} else {
				senderAddress = try ProtocolAddress(name: "\(senderDomain)_\(senderId)", deviceId: UInt32(Constants.receiverDeviceId))
				distributionId = senderStore.getSenderDistributionID(senderID: senderId, groupId: groupID, isCreateNew: false)
			}
			let result = await initSessionUserInGroup(address: senderAddress,
										 distributionId: distributionId,
										 domain: ownerDomain,
										 groupID: groupID,
										 clientID: senderId,
										 isForceProcess: false)
			if !result {
				return nil
			}
			do {
				let plaintextFromAlice = try groupDecrypt(message, from: senderAddress, store: senderStore, context: NullContext())
				Debug.DLog("decrypt group message success")
				return String(bytes: plaintextFromAlice, encoding: .utf8)
			} catch SignalError.duplicatedMessage {
				Debug.DLog("decrypt group message fail duplicate message")
				return nil
			} catch {
				Debug.DLog("decrypt group message 1st time fail \(error)")
				let initSessionAgain = await initSessionUserInGroup(address: senderAddress,
																	distributionId: distributionId,
																	domain: ownerDomain,
																	groupID: groupID,
																	clientID: senderId,
																	isForceProcess: true)
				if initSessionAgain {
					let plainText = try groupDecrypt(message, from: senderAddress, store: senderStore, context: NullContext())
					return String(bytes: plainText, encoding: .utf8)
				} else {
					Debug.DLog("decrypt group fail")
					return nil
				}
			}
		} catch {
			Debug.DLog("decrypt group fail \(error)")
			return nil
		}
	}
	
	func initSessionUserInGroup(address: ProtocolAddress, distributionId: UUID?, domain: String, groupID: Int64, clientID: String, isForceProcess: Bool) async -> Bool {
		do {
			if distributionId == nil || isForceProcess {
				guard let server = channelStorage.realmManager.getServer(by: domain) else { return false }
				var request = Signal_GroupGetClientKeyRequest()
				request.groupID = groupID
				request.clientID = clientID
				let response = await channelStorage.getChannel(domain: domain).groupGetClientKey(request)
				switch response {
				case .success(let result):
					print(result)
					let receivedAliceDistributionMessage = try SenderKeyDistributionMessage(bytes: [UInt8](result.clientKey.clientKeyDistribution))
					try processSenderKeyDistributionMessage(receivedAliceDistributionMessage,
															from: address,
															store: senderStore,
															context: NullContext())
					senderStore.saveSenderDistributionID(senderID: clientID, groupId: groupID)
					Debug.DLog("init session user in group get sender key success")
					return true
				case .failure(let error):
					Debug.DLog("init session user in group get sender key false \(error)")
					return false
				}
				
			} else {
				Debug.DLog("init session user in group success")
				return true
			}
		} catch {
			Debug.DLog("init session user in group error \(error)")
			return false
		}
	}
	
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}

extension Sequence {
	func asyncForEach(
		_ operation: (Element) async throws -> Void
	) async rethrows {
		for element in self {
			try await operation(element)
		}
	}
}
