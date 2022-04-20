//
//  CKAccountSignalEncryptionManager.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 10/30/20.
//

import UIKit
import SignalProtocolObjC
import YapDatabase

public enum SignalEncryptionError: Error {
    case unableToCreateSignalContext
}

class CKAccountSignalEncryptionManager {
    let storage: CKSignalStorageManager
    var signalContext: SignalContext
    var mySignalPreKey: SignalSignedPreKey?
    var myPreKey: SignalPreKey?
    
    // In OMEMO world the registration ID is used as the device id and all devices have registration ID of 0.
    open var registrationId: UInt32 {
        return self.storage.getLocalRegistrationId()
    }
    
    open var identityKeyPair: SignalIdentityKeyPair {
        return self.storage.getIdentityKeyPair()
    }
    
    init(accountKey: String, databaseConnection: YapDatabaseConnection) throws {
        self.storage = CKSignalStorageManager(accountKey: accountKey,
                                              databaseConnection: databaseConnection,
                                              delegate: nil)
        let signalStorage = SignalStorage(signalStore: self.storage)
        guard let context = SignalContext(storage: signalStorage) else {
            throw SignalEncryptionError.unableToCreateSignalContext
        }
        self.signalContext = context
        self.storage.delegate = self
    }
}

extension CKAccountSignalEncryptionManager {
    internal func keyHelper() -> SignalKeyHelper? {
        return SignalKeyHelper(context: self.signalContext)
    }
    
    public func generateRandomSignedPreKey() -> SignalSignedPreKey? {
        
        guard let preKeyId = self.keyHelper()?.generateRegistrationId() else {
            return nil
        }
        guard let signedPreKey = self.keyHelper()?.generateSignedPreKey(withIdentity: self.identityKeyPair, signedPreKeyId: preKeyId),
              let data = signedPreKey.serializedData() else {
            return nil
        }
        if self.storage.storeSignedPreKey(data, signedPreKeyId: signedPreKey.preKeyId) {
            return signedPreKey
        }
        return nil
    }
    
    /**
     * This creates all the information necessary to publish a 'bundle' to your XMPP server via PEP. It generates prekeys 0 to 99.
     */
    public func generateOutgoingBundle(_ preKeyCount: UInt) throws -> CKBundle {
        let identityKeyPair = self.storage.getIdentityKeyPair()
        let deviceId = self.registrationId
        
        // Fetch existing signed pre-key to prevent regeneration
        // The existing storage code only allows for storage of
        // a single signedprekey per account, so regeneration
        // will break things.
        var signalSignedPreKey: SignalSignedPreKey?
        self.storage.databaseConnection.read { (transaction) in
            guard let signedPreKeyDataObject = CKSignalSignedPreKey.fetchObject(withUniqueID: self.storage.accountKey,
                                                                                transaction: transaction) else {
                return
            }
            do {
                signalSignedPreKey = try SignalSignedPreKey(serializedData: signedPreKeyDataObject.keyData)
            } catch {
                NSLog("Error parsing SignalSignedPreKey")
            }
        }
        // If there is no existing one, generate a new one
        if signalSignedPreKey == nil {
            signalSignedPreKey = self.generateRandomSignedPreKey()
        }
        guard let signedPreKey = signalSignedPreKey,
              let data = signedPreKey.serializedData() else {
            throw CKBundleError.keyGeneration
        }
        guard let preKeys = self.generatePreKeys(1, count: preKeyCount),
              let preKeyFirst = preKeys.first,
              let dataPreKey = preKeyFirst.serializedData() else {
            throw CKBundleError.keyGeneration
        }
        myPreKey = preKeyFirst
        mySignalPreKey = signedPreKey
        let bundle = try CKBundle(deviceId: deviceId,
                                  registrationId: self.registrationId,
                                  identity: identityKeyPair,
                                  signedPreKey: signedPreKey,
                                  preKeys: preKeys)
        _ = self.storage.storePreKey(dataPreKey, preKeyId: preKeyFirst.preKeyId)
        _ = self.storage.storeSignedPreKey(data, signedPreKeyId: signedPreKey.preKeyId)
        return bundle
    }
    
    public func generatePreKeys(_ start: UInt, count: UInt) -> [SignalPreKey]? {
        guard let preKeys = self.keyHelper()?.generatePreKeys(withStartingPreKeyId: start,
                                                              count: count) else {
            return nil
        }
        if self.storage.storeSignalPreKeys(preKeys) {
            return preKeys
        }
        return nil
    }
    
    public func sessionRecordExistsForUsername(_ username: String, deviceId: Int32) -> Bool {
        let address = SignalAddress(name: username.lowercased(), deviceId: deviceId)
        return self.storage.sessionRecordExists(for: address)
    }
    
    public func removeSessionRecordForUsername(_ username: String, deviceId: Int32) -> Bool {
        let address = SignalAddress(name: username.lowercased(), deviceId: deviceId)
        return self.storage.deleteSessionRecord(for: address)
    }
    
    public func senderKeyExistsForUsername(_ username: String, deviceId: Int32, groupId: Int64) -> Bool {
        let address = SignalAddress(name: username.lowercased(), deviceId: deviceId)
        let senderKeyName = SignalSenderKeyName(groupId: String(groupId), address: address)
        return self.storage.senderKeyExists(for: senderKeyName)
    }
}

// MARK: - Single user
extension CKAccountSignalEncryptionManager {
    /**
     * This processes fetched OMEMO bundles. After you consume a bundle you can then create preKeyMessages to send to the contact.
     */
    public func consumeIncoming(_ address: SignalAddress, signalPreKeyBundle: SignalPreKeyBundle) throws {
        let sessionBuilder = SignalSessionBuilder(address: address, context: self.signalContext)
        return try sessionBuilder.processPreKeyBundle(signalPreKeyBundle)
    }
    
    public func encryptToAddress(_ data: Data, name: String, deviceId: Int32) throws -> SignalCiphertext {
        let address = SignalAddress(name: name.lowercased(), deviceId: deviceId)
        let sessionCipher = SignalSessionCipher(address: address, context: self.signalContext)
        return try sessionCipher.encryptData(data)
    }
    
    public func decryptFromAddress(_ data: Data, name: String, deviceId: Int32) throws -> Data {
        let address = SignalAddress(name: name.lowercased(), deviceId: deviceId)
        let sessionCipher = SignalSessionCipher(address: address, context: self.signalContext)
        let cipherText = SignalCiphertext(data: data, type: .preKeyMessage)
        return try sessionCipher.decryptCiphertext(cipherText)
    }
}

// MARK: - Group user
extension CKAccountSignalEncryptionManager {
    public func consumeIncoming(toGroup groupId: Int64,
                                address: SignalAddress,
                                skdmDtata: Data) throws {
        let sessionBuilder = SignalGroupSessionBuilder(context: self.signalContext)
        let senderKeyName = SignalSenderKeyName(groupId: String(groupId), address: address)
        
        let signalSKDM = try SignalSKDM(data: skdmDtata, context: self.signalContext)
        return try sessionBuilder.processSession(with: senderKeyName, skdm: signalSKDM)
    }
    
    public func encryptToGroup(_ data: Data, groupId: Int64, name: String, deviceId: Int32) throws -> SignalCiphertext {
        let address = SignalAddress(name: name.lowercased(), deviceId: deviceId)
        let senderKeyName = SignalSenderKeyName(groupId: String(groupId), address: address)
        let groupCipher = SignalGroupCipher(senderKeyName: senderKeyName, context: self.signalContext)
        return try groupCipher.encryptData(data)
    }
    
    public func decryptFromGroup(_ data: Data, groupId: Int64, name: String, deviceId: Int32) throws -> Data {
        let address = SignalAddress(name: name.lowercased(), deviceId: deviceId)
        let senderKeyName = SignalSenderKeyName(groupId: String(groupId), address: address)
        
        let groupCipher = SignalGroupCipher(senderKeyName: senderKeyName, context: self.signalContext)
        let cipherText = SignalCiphertext(data: data, type: .senderKeyMessage)
        return try groupCipher.decryptCiphertext(cipherText)
    }
}

extension CKAccountSignalEncryptionManager: CKSignalStorageManagerDelegate {
    
    public func generateNewIdenityKeyPairForAccountKey(_ accountKey: String) -> CKAccountSignalIdentity {
        let keyHelper = self.keyHelper()!
        let keyPair = keyHelper.generateIdentityKeyPair()!
        let registrationId = keyHelper.generateRegistrationId()
        return CKAccountSignalIdentity(accountKey: accountKey,
                                       identityKeyPair: keyPair,
                                       registrationId: registrationId)!
    }
}
