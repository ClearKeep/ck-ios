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

public protocol IMessageService {
	func sendMessageInPeer(senderId: String,
						   ownerWorkspace: String,
						   receiverId: String,
						   receiverWorkSpaceDomain: String,
						   groupId: Int64,
						   plainMessage: String,
						   isForceProcessKey: Bool,
						   cachedMessageId: Int) async -> Result<Bool, Error>
	
	func sendMessageInGroup(senderId: String,
							ownerWorkspace: String,
							groupId: Int64,
							plainMessage: String,
							cachedMessageId: Int) async -> Result<Bool, Error>
	
	func getMessage(server: RealmServer, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<Message_GetMessagesInGroupResponse, Error>
}

public class MessageService {
	 let clientStore: ClientStore
	 let signalStore: ISignalProtocolInMemoryStore
	 let senderStore: ISenderKeyStore
		
	public init(clientStore: ClientStore, signalStore: ISignalProtocolInMemoryStore, senderStore: ISenderKeyStore) {
		self.clientStore = clientStore
		self.signalStore = signalStore
		self.senderStore = senderStore
	}
}

extension MessageService: IMessageService {
	public func sendMessageInPeer(senderId: String, ownerWorkspace: String, receiverId: String, receiverWorkSpaceDomain: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async -> Result<Bool, Error> {
		Debug.DLog("Sending message")
		do {
			let receiverAddress = try ProtocolAddress(name: "\(receiverWorkSpaceDomain)_\(receiverId)", deviceId: UInt32(Constants.senderDeviceId))
			Debug.DLog("Sending message1")
			let existingSession = try signalStore.sessionStore.loadSession(for: receiverAddress, context: NullContext())
			Debug.DLog("Sending message2")
			if existingSession == nil || isForceProcessKey {
				Debug.DLog("Sending message3")
				let isSuccess = await requestKeyPeer(senderId: senderId, senderDomain: ownerWorkspace, receiverId: receiverId, receiverDomain: receiverWorkSpaceDomain)
				if !isSuccess {
					Debug.DLog("Send message fail - Can't request key peer")
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
				for: ProtocolAddress(name: "\(ownerWorkspace)_\(senderId)", deviceId: UInt32(Constants.senderDeviceId)),
				sessionStore: signalStore.sessionStore,
				identityStore: signalStore.identityStore,
				context: NullContext())
			
			var request = Message_PublishRequest()
			request.clientID = receiverId
			request.fromClientDeviceID = clientStore.getUniqueDeviceId()
			request.groupID = groupId
			request.message = Data(message.serialize())
			request.senderMessage = Data(messageSender.serialize())
			
			guard let server = channelStorage.realmManager.getServer(by: ownerWorkspace) else { return .failure(ServerError.unknown) }
			let response = await channelStorage.getChannel(domain: server.serverDomain, accessToken: server.accessKey, hashKey: server.hashKey).sendMessage(request)
			switch response {
			case .success(let messageRespone):
				// TODO: save message
				Debug.DLog("Send message success - \(messageRespone)")
				return .success(true)
			case .failure(let error):
				Debug.DLog("Send message fail - \(error.localizedDescription)")
				return .failure(ServerError(error))
			}
		} catch {
			Debug.DLog("Send message fail - Can't encrypt message")
			return .failure(ServerError.unknown)
		}
		
	}
	
	public func sendMessageInGroup(senderId: String, ownerWorkspace: String, groupId: Int64, plainMessage: String, cachedMessageId: Int) async -> Result<Bool, Error> {
		do {
			// if user hasn't joined this group -> registerSenderKey
//			let result = await registerSenderKeyToGroup(groupID: groupId, clientId: senderId, domain: ownerWorkspace)
//			if result {
                Debug.DLog("Sending group message")
				let senderAddress = try ProtocolAddress(name: "\(ownerWorkspace)_\(senderId)", deviceId: UInt32(Constants.senderDeviceId))
            Debug.DLog("Sending group message1")
				guard let messageData = plainMessage.data(using: .utf8) else {
					return .failure(ServerError.unknown)
				}
            Debug.DLog("Sending group message2")
				let distributionId = senderStore.getSenderDistributionID(from: senderAddress, groupId: groupId)
            Debug.DLog("Sending group message3")
				let ciphertext = try groupEncrypt(messageData, from: senderAddress, distributionId: distributionId, store: senderStore, context: NullContext())
            Debug.DLog("Sending group message4")
				var request = Message_PublishRequest()
				//request.clientID = senderId
				request.fromClientDeviceID = clientStore.getUniqueDeviceId()
				request.groupID = groupId
				request.message = Data(ciphertext.serialize())
				request.senderMessage = Data(ciphertext.serialize())
				guard let server = channelStorage.realmManager.getServer(by: ownerWorkspace) else { return .failure(ServerError.unknown) }
				let response = await channelStorage.getChannel(domain: server.serverDomain, accessToken: server.accessKey, hashKey: server.hashKey).sendMessage(request)
            Debug.DLog("Sending group message5")
				switch response {
				case .success(let messageRespone):
                    Debug.DLog("Sending group message success")
					// TODO: save message
					return .success(true)
				case .failure(let error):
					Debug.DLog("Send message group fail - \(error.localizedDescription)")
					return .failure(ServerError(error))
				}
			//}
		} catch {
			Debug.DLog("Send message group fail - Can't encrypt message")
			return .failure(ServerError.unknown)
		}
	}
	
	public func getMessage(server: RealmServer, groupId: Int64, loadSize: Int, lastMessageAt: Int64) async -> Result<Message_GetMessagesInGroupResponse, Error> {
		var request = Message_GetMessagesInGroupRequest()
		request.groupID = groupId
		request.lastMessageAt = lastMessageAt
		request.offSet = Int32(loadSize)
		
		let response = await channelStorage.getChannel(domain: server.serverDomain, accessToken: server.accessKey, hashKey: server.hashKey).getMessage(request)
		switch response {
		case .success(let messageRespone):
			Debug.DLog("Get message success - \(messageRespone)")
            messageRespone.lstMessage.forEach { message in
//				if message.fromClientID == "8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65" {
//					let mes = decryptPeerMessage(senderName: "stag1.clearkeep.org:25000_8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65", message: message.message)
//					print("1st message: \(mes)")
//				} else {
//					let mes = decryptPeerMessage(senderName: "stag1.clearkeep.org:25000_8e32813b-01b8-4c6a-bec7-0ff5c5460e20", message: message.message)
//					print("2st message: \(mes)")
//				}
                Task {
                    let mes = await decryptGroupMessage(senderId: message.fromClientID, senderDomain: "stag1.clearkeep.org:25000_8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65", ownerId: "8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65", ownerDomain: "stag1.clearkeep.org:25000_8a280b5a-9b40-48d8-9af8-6d9ae1fcfc65", groupID: Int64(14), message: message.message)
                    print("2st message: \(mes)")
                }
                
			}
			return .success(messageRespone)
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
		Debug.DLog("initSessionUserPeer with \(clientId)")
		var request = Signal_PeerGetClientKeyRequest()
		request.clientID = clientId
		request.workspaceDomain = workspaceDomain
		guard let server = channelStorage.realmManager.getServer(by: workspaceDomain) else { return false }
		let response = await channelStorage.getChannel(domain: server.serverDomain, accessToken: server.accessKey, hashKey: server.hashKey).peerGetClientKey(request)
		
		switch response {
		case .success(let recipientResponse):
			Debug.DLog("get peerGetClientKey success \(recipientResponse)")
			do {
				let preKey = try PreKeyRecord(bytes: recipientResponse.preKey)
				let signedPreKey = try SignedPreKeyRecord(bytes: recipientResponse.signedPreKey)
				print("sduuuuu")
				let identityKeyPublic = try IdentityKey(bytes: recipientResponse.identityKeyPublic)
				print("sdgsdgsdgsg")
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
				print("1111")
				let addressName = "\(workspaceDomain)_\(clientId)"
				let address = try ProtocolAddress(name: addressName, deviceId: UInt32(Constants.senderDeviceId))
				print("2222")
				try processPreKeyBundle(
					retrievedPreKeyBundle,
					for: address,
					sessionStore: signalStore.sessionStore,
					identityStore: signalStore.identityStore,
					context: NullContext())
				print("3333")
				return true
			} catch {
				Debug.DLog("peerGetClientKey processPreKeyBundle exception: \(error)")
				return false
			}
		case .failure(let error):
			Debug.DLog("peerGetClientKey exception: \(error)")
			return false
		}
	}
	
	func registerSenderKeyToGroup(groupID: Int64, clientId: String, domain: String) async -> Bool {
		do {
			let identityKey = try signalStore.identityStore.identityKeyPair(context: NullContext())
			let privateKey = identityKey.privateKey
			
			let senderAddress = try ProtocolAddress(name: "\(domain)_\(clientId)", deviceId: UInt32(Constants.senderDeviceId))
			let distributionId = senderStore.getSenderDistributionID(from: senderAddress, groupId: groupID)
			let sentAliceDistributionMessage = try SenderKeyDistributionMessage(from: senderAddress, distributionId: distributionId, store: senderStore, context: NullContext())
			
			let pbkdf2 = PBKDF2(passPharse: bytesConvertToHexString(bytes: privateKey.serialize()))
			
			let key = KeyHelper.generateIdentityKeyPair()
			let encryptedGroupPrivateKey = pbkdf2.encrypt(data: key.privateKey.serialize(), saltHex: "a9bab88a") // retrieve saltHex from database
			
			let senderKey = try senderStore.loadSenderKey(from: senderAddress, distributionId: distributionId, context: NullContext())
			
			var request = Signal_GroupRegisterClientKeyRequest()
			request.privateKey = bytesConvertToHexString(bytes: encryptedGroupPrivateKey ?? [])
			request.groupID = groupID
			request.deviceID = Int32(Constants.senderDeviceId)
			request.publicKey = Data(key.publicKey.serialize())
			request.clientKeyDistribution = Data(sentAliceDistributionMessage.serialize())
			request.senderKey = Data(senderKey?.serialize() ?? [])
			request.senderKeyID = Int64(distributionId.uuidString) ?? 0
			
			guard let server = channelStorage.realmManager.getServer(by: domain) else { return false }
			let response = await channelStorage.getChannel(domain: server.serverDomain, accessToken: server.accessKey, hashKey: server.hashKey).groupRegisterClientKey(request)
			switch response {
			case .success(let result):
				return true
			case .failure(let error):
				return false
			}
		} catch {
			return false
		}
	}
	
	func decryptPeerMessage(senderName: String, message: Data) -> String? {
		do {
			let signalProtocolAddress = try ProtocolAddress(name: senderName, deviceId: UInt32(Constants.receiverDeviceId))
			print("decrypt 1")
			let preKeyMessage = try PreKeySignalMessage(bytes: message)
			print("decrypt 2")
			let decryptMessage = try signalDecryptPreKey(
				message: preKeyMessage, from: signalProtocolAddress, sessionStore:
				signalStore.sessionStore, identityStore: signalStore.identityStore,
				preKeyStore: signalStore.preKeyStore,
				signedPreKeyStore: signalStore.signedPreKeyStore, context: NullContext())
			print("decrypt 3")
			return String(bytes: decryptMessage, encoding: .utf8)
		} catch {
			print("decrypt messageEror \(error)")
			return nil
		}
	}
	
	func decryptGroupMessage(senderId: String, senderDomain: String, ownerId: String, ownerDomain: String, groupID: Int64, message: Data) async -> String? {
		do {
            print("decrypt group 1")
			let senderAddress: ProtocolAddress
			let distributionId: UUID
			if senderId == ownerId {
                print("decrypt group 2")
				senderAddress = try ProtocolAddress (name: "\(senderDomain)_\(senderId)", deviceId: UInt32(Constants.senderDeviceId))
				distributionId = senderStore.getSenderDistributionID(from: senderAddress, groupId: groupID)
			} else {
                print("decrypt group 3")
				senderAddress = try ProtocolAddress (name: "\(senderDomain)_\(senderId)", deviceId: UInt32(Constants.receiverDeviceId))
				distributionId = senderStore.getSenderDistributionID(from: senderAddress, groupId: groupID)
			}
			await initSessionUserInGroup(address: senderAddress, distributionId:
											distributionId, domain: ownerDomain, groupID: groupID,
										 clientID: senderId, isForceProcess: false)
			do {
                print("decrypt group 4")
				let plaintextFromAlice = try groupDecrypt(message, from: senderAddress, store: senderStore, context: NullContext())
				return String(bytes: plaintextFromAlice, encoding: .utf8)
			} catch {
                print("decrypt group fail first\(error)")
                print("decrypt group 5")
				let initSessionAgain = await initSessionUserInGroup(address: senderAddress, distributionId:
																		distributionId, domain: ownerDomain, groupID: groupID,
																	clientID: senderId, isForceProcess: true)
				if initSessionAgain {
                    print("decrypt group 6")
					let plainText = try groupDecrypt(message, from: senderAddress, store: senderStore, context: NullContext())
					return String(bytes: plainText, encoding: .utf8)
				} else {
                    print("decrypt group fail second \(error)")
					return nil
				}
			}
		} catch {
            print("decrypt group fail \(error)")
			return nil
		}
	}
	
	@discardableResult
	func initSessionUserInGroup(address: ProtocolAddress, distributionId: UUID, domain: String, groupID: Int64, clientID: String, isForceProcess: Bool) async -> Bool {
		do {
			let senderKeyRecord = try senderStore.loadSenderKey(from: address, distributionId: distributionId, context: NullContext())
			if senderKeyRecord == nil || isForceProcess {
				guard let server = channelStorage.realmManager.getServer(by: domain) else { return false }
				var request = Signal_GroupGetClientKeyRequest()
				request.groupID = groupID
				request.clientID = clientID
				guard let server = channelStorage.realmManager.getServer(by: domain) else { return false }
				let response = await channelStorage.getChannel(domain: domain, accessToken: server.accessKey, hashKey: server.hashKey).groupGetClientKey(request)
				switch response {
				case .success(let result):
					let receivedAliceDistributionMessage = try SenderKeyDistributionMessage(bytes: [UInt8](result.clientKey.clientKeyDistribution))
					try processSenderKeyDistributionMessage(receivedAliceDistributionMessage,
															from: address,
															store: senderStore,
															context: NullContext())
					return true
				case .failure(let error):
                    print("decrypt init session in group fail 1\(error)")
					return false
				}
				
			}
			return true
		} catch {
            print("decrypt init session in group fail \(error)")
			return false
		}
	}
	
	func bytesConvertToHexString(bytes: [UInt8]) -> String {
		return bytes.compactMap {
			String(format: "%02x", $0)
		}.joined()
	}
}
