//
//  MessageService.swift
//  ChatSecure
//
//  Created by NamNH on 13/04/2022.
//

import Foundation
import Networking
import Common
import SignalProtocolObjC
import YapDatabase

protocol IMessageService {
	func sendMessageInPeer(senderId: String,
						   senderWorkspace: String,
						   receiverId: String,
						   receiverWorkSpace: String,
						   groupId: Int64,
						   plainMessage: String,
						   isForceProcessKey: Bool,
						   cachedMessageId: Int) async
	
	func sendMessageInGroup(senderId: String,
							senderWorkspace: String,
							receiverId: String,
							groupId: Int64,
							plainMessage: String,
							cachedMessageId: Int) async
}

class MessageService {
	var clientStore: ClientStore
	var connectionDb: YapDatabaseConnection?
	private(set) var isLatestPeerSignalKeyProcessed: Bool = false
	
	public init() {
		clientStore = ClientStore()
		connectionDb = CKDatabaseManager.shared.database?.newConnection()
	}
}

extension MessageService: IMessageService {
	func sendMessageInPeer(senderId: String, senderWorkspace: String, receiverId: String, receiverWorkSpace: String, groupId: Int64, plainMessage: String, isForceProcessKey: Bool, cachedMessageId: Int) async {
		if isForceProcessKey {
			let isSuccess = await requestKeyPeer(by: receiverId, workspaceDomain: receiverWorkSpace)
			if isSuccess {
				await sendMessageInPeer(senderId: senderId, senderWorkspace: senderWorkspace, receiverId: receiverId, receiverWorkSpace: receiverWorkSpace, groupId: groupId, plainMessage: plainMessage, isForceProcessKey: false, cachedMessageId: cachedMessageId)
			} else {
				Debug.DLog("Send message fail - Can't request key peer")
				return
			}
			return
		}
		
		let plainMessage = plainMessage.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !plainMessage.isEmpty, let payload = plainMessage.data(using: .utf8) else {
			return
		}
		
		let receiverSignalAddress = CKSignalProtocolAddress(owner: Owner(clientId: receiverId, domain: receiverWorkSpace), deviceId: channelStorage.config.senderDeviceId)
		let senderSignalAddress = CKSignalProtocolAddress(owner: Owner(clientId: senderId, domain: senderWorkspace), deviceId: channelStorage.config.senderDeviceId)
		
		do {
			guard
				let receiverSessionCipher = try CKSignalCoordinate.shared.ourEncryptionManager?.encryptToAddress(payload,
																												 address: receiverSignalAddress),
				let senderSessionCipher = try CKSignalCoordinate.shared.ourEncryptionManager?.encryptToAddress(payload,
																											   address: senderSignalAddress) else
			{ return }
			
			var request = Message_PublishRequest()
			request.clientID = receiverId
			request.fromClientDeviceID = clientStore.getUniqueDeviceId()
			request.groupID = groupId
			request.message = receiverSessionCipher.data
			request.senderMessage = senderSessionCipher.data
			
			let response = await channelStorage.getChannels(domain: senderWorkspace).sendMessage(request)
			switch response {
			case .success(let message):
				print(message)
			case .failure(let error):
				Debug.DLog("Send message fail - \(error.localizedDescription)")
			}
		} catch {
			Debug.DLog("Send message fail - \(error.localizedDescription)")
		}
	}
	
	func sendMessageInGroup(senderId: String, senderWorkspace: String, receiverId: String, groupId: Int64, plainMessage: String, cachedMessageId: Int) async {
		let plainMessage = plainMessage.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !plainMessage.isEmpty, let payload = plainMessage.data(using: .utf8) else {
			return
		}
		
		let senderSignalAddress = CKSignalProtocolAddress(owner: Owner(clientId: senderId, domain: senderWorkspace), deviceId: channelStorage.config.senderDeviceId)
		
		do {
			guard let senderSessionCipher = try CKSignalCoordinate.shared.ourEncryptionManager?.encryptToGroup(payload,
																										 groupId: groupId,
																										 address: senderSignalAddress) else { return }
			var request = Message_PublishRequest()
			request.fromClientDeviceID = clientStore.getUniqueDeviceId()
			request.groupID = groupId
			request.message = senderSessionCipher.data
			request.senderMessage = senderSessionCipher.data
			
			let response = await channelStorage.getChannels(domain: senderWorkspace).sendMessage(request)
			switch response {
			case .success(let message):
				print(message)
			case .failure(let error):
				Debug.DLog("Send message fail - \(error.localizedDescription)")
			}
		} catch {
			Debug.DLog("Send message error: \(error) to group \(groupId)")
		}
	}
}

private extension MessageService {
	func requestKeyPeer(by clientId: String, workspaceDomain: String) async -> Bool {
		var request = Signal_PeerGetClientKeyRequest()
		request.clientID = clientId
		request.workspaceDomain = workspaceDomain
		
		let response = await channelStorage.getChannels(domain: workspaceDomain).peerGetClientKey(request)
		
		switch response {
		case .success(let recipientResponse):
			if let connectionDb = connectionDb,
			   let myAccount = CKSignalCoordinate.shared.myAccount {
				connectionDb.readWrite { transaction in
					if myAccount.refetch(with: transaction) != nil {
						let myBuddy = CKBuddy.fetchBuddy(username: recipientResponse.clientID,
														 accountUniqueId: myAccount.uniqueId,
														 transaction: transaction)
						if myBuddy == nil {
							let buddy = CKBuddy()
							buddy?.accountUniqueId = myAccount.uniqueId
							buddy?.username = recipientResponse.clientID
							buddy?.save(with: transaction)
							
							let device = CKDevice(deviceId: NSNumber(value: recipientResponse.deviceID),
												  trustLevel: .trustedTofu,
												  parentKey: buddy?.uniqueId ?? "",
												  parentCollection: CKBuddy.collection,
												  publicIdentityKeyData: nil,
												  lastSeenDate: nil)
							device.save(with: transaction)
						} else {
							myBuddy?.save(with: transaction)
							let device = CKDevice(deviceId: NSNumber(value: recipientResponse.deviceID),
												  trustLevel: .trustedTofu,
												  parentKey: myBuddy?.uniqueId ?? "",
												  parentCollection: CKBuddy.collection,
												  publicIdentityKeyData: nil,
												  lastSeenDate: nil)
							device.save(with: transaction)
						}
					}
				}
			}
			processKeyStoreHasPrivateKey(recipientResponse: recipientResponse)
			
			return true
		case .failure(let error):
			Debug.DLog("peerGetClientKey exception: \(error)")
			return false
		}
	}
	
	func processKeyStoreHasPrivateKey(recipientResponse: Signal_PeerGetClientKeyResponse) {
		if let ourEncryptionMng = CKSignalCoordinate.shared.ourEncryptionManager {
			do {
				let remotePrekey = try SignalPreKey(serializedData: recipientResponse.preKey)
				let remoteSignedPrekey = try SignalSignedPreKey(serializedData: recipientResponse.signedPreKey)
				
				guard let preKeyKeyPair = remotePrekey.keyPair,
					  let signedPrekeyKeyPair = remoteSignedPrekey.keyPair else {
					return
				}
				
				let signalPreKeyBundle = try SignalPreKeyBundle(registrationId: UInt32(recipientResponse.registrationID),
																deviceId: UInt32(recipientResponse.deviceID),
																preKeyId: UInt32(recipientResponse.preKeyID),
																preKeyPublic: preKeyKeyPair.publicKey,
																signedPreKeyId: UInt32(recipientResponse.signedPreKeyID),
																signedPreKeyPublic: signedPrekeyKeyPair.publicKey,
																signature: recipientResponse.signedPreKeySignature,
																identityKey: recipientResponse.identityKeyPublic)
				
				let remoteAddress = SignalAddress(name: recipientResponse.clientID,
												  deviceId: recipientResponse.deviceID)
				try ourEncryptionMng.consumeIncoming(remoteAddress, signalPreKeyBundle: signalPreKeyBundle)
			} catch {
				Debug.DLog("processKeyStoreHasPrivateKey exception: \(error)")
			}
		}
	}
}
