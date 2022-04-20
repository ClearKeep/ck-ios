//
//  CKSignalStorageManager.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 10/29/20.
//

import Foundation
import YapDatabase
import SignalProtocolObjC

protocol CKSignalStorageManagerDelegate: class {
    /** Generate a new account key*/
    func generateNewIdenityKeyPairForAccountKey(_ accountKey: String) -> CKAccountSignalIdentity
}

class CKSignalStorageManager: NSObject {
    public let accountKey: String
    public let databaseConnection: YapDatabaseConnection
    open weak var delegate: CKSignalStorageManagerDelegate?
    /**
     Create a Signal Store Manager for each account.
     
     - parameter accountKey: The yap key for the parent account.
     - parameter databaseConnection: The yap connection to use internally
     - parameter delegate: An object that handles CKSignalStorageManagerDelegate
     */
    public init(accountKey: String,
                databaseConnection: YapDatabaseConnection,
                delegate: CKSignalStorageManagerDelegate?) {
        self.accountKey = accountKey
        self.databaseConnection = databaseConnection
        self.delegate = delegate
    }
    
    /**
     Convenience function to create a new CKAccountSignalIdentity and save it to yap
     
     - returns: an CKAccountSignalIdentity that is already saved to the database
     */
    fileprivate func generateNewIdenityKeyPair() -> CKAccountSignalIdentity {
        // Might be a better way to guarantee we have an CKAccountSignalIdentity
        let identityKeyPair = (self.delegate?.generateNewIdenityKeyPairForAccountKey(self.accountKey))!
        
        self.databaseConnection.readWrite { (transaction) in
            identityKeyPair.save(with: transaction)
        }
        
        return identityKeyPair
    }
    
    // MARK: Database Utilities
    
    /**
     Fetches the CKAccountSignalIdentity for the account key from this class.
     
     returns: An CKAccountSignalIdentity or nil if none was created and stored.
     */
    fileprivate func accountSignalIdentity() -> CKAccountSignalIdentity? {
        var identityKeyPair: CKAccountSignalIdentity?
        
        self.databaseConnection.read { (transaction) in
            identityKeyPair = CKAccountSignalIdentity.fetchObject(withUniqueID: self.accountKey,
                                                                  transaction: transaction)
        }
        
        return identityKeyPair
    }
    
    fileprivate func storePreKey(_ preKey: Data,
                                 preKeyId: UInt32,
                                 transaction: YapDatabaseReadWriteTransaction) -> Bool {
        guard let preKeyDatabaseObject = CKSignalPreKey(accountKey: self.accountKey,
                                                        keyId: preKeyId,
                                                        keyData: preKey) else {
            return false
        }
        preKeyDatabaseObject.save(with: transaction)
        return true
    }
    
    /**
     Save a bunch of pre keys in one database transaction
     
     - parameters preKeys: The array of pre-keys to be stored
     
     - return: Whether the storage was successufl
     */
    open func storeSignalPreKeys(_ preKeys: [SignalPreKey]) -> Bool {
        if preKeys.count == 0 {
            return true
        }
        
        var success = false
        self.databaseConnection.readWrite { (transaction) in
            for pKey in preKeys {
                if let data = pKey.serializedData() {
                    success = self.storePreKey(data,
                                               preKeyId: pKey.preKeyId,
                                               transaction: transaction)
                } else {
                    success = false
                }
                
                if !success {
                    break
                }
            }
        }
        return success
    }
    
    /**
     Returns the current max pre-key id for this account. This includes both deleted and existing pre-keys. This is fairly quick as it uses a secondary index and
     aggregate function MAX(CKYapDatabaseSignalPreKeyIdSecondaryIndexColumnName) WHERE CKYapDatabaseSignalPreKeyAccountKeySecondaryIndexColumnName =?, self.accountKey
     
     returns: The current max in the yap database. If there are no pre-keys then returns none.
     */
    internal func currentMaxPreKeyId() -> UInt32? {
        var maxId: UInt32?
        self.databaseConnection.read { (transaction) in
            guard let secondaryIndexTransaction = transaction.ext(SecondaryIndexName.signal) as? YapDatabaseSecondaryIndexTransaction else {
                return
            }
            let query = YapDatabaseQuery.init(aggregateFunction: "MAX(\(SignalIndexColumnName.preKeyId))", string: "WHERE \(SignalIndexColumnName.preKeyAccountKey) = ?", parameters: ["\(self.accountKey)"])
            if let result = secondaryIndexTransaction.performAggregateQuery(query) as? NSNumber {
                maxId = result.uint32Value
            }
        }
        return maxId
    }
    
    /**
     Fetch all pre-keys for this class's account. This can include deleted pre-keys which are CKSignalPreKey witout any keyData.
     
     - parameter includeDeleted: If deleted pre-keys are included in the result
     
     - return: An array of CKSignalPreKey(s). If ther eare no pre-keys then the array will be empty.
     */
    internal func fetchAllPreKeys(_ includeDeleted: Bool) -> [CKSignalPreKey] {
        var preKeys = [CKSignalPreKey]()
        self.databaseConnection.read { (transaction) in
            guard let secondaryIndexTransaction = transaction.ext(SecondaryIndexName.signal) as? YapDatabaseSecondaryIndexTransaction else {
                return
            }
            
            let query = YapDatabaseQuery(string: "WHERE (CKYapDatabaseSignalPreKeyAccountKeySecondaryIndexColumnName) = ?",
                                         parameters: ["\(self.accountKey)"])
            secondaryIndexTransaction.iterateKeysAndObjects(matching: query,
                                                            using: { _, _, object, _ in
                guard let preKey = object as? CKSignalPreKey else {
                    return
                }
                
                if preKey.keyData != nil || includeDeleted {
                    preKeys.append(preKey)
                }
            })
        }
        return preKeys
    }
    
    /**
     This fetches the associated account's bundle from yap. If any piece of the bundle is missing it returns nil.
     
     - return: A complete outgoing bundle.
     */
    open func fetchOurExistingBundle() throws -> CKBundle {
        var signedPreKey: CKSignalSignedPreKey?
        var identity: CKAccountSignalIdentity?
        
        // Fetch and create the base bundle
        self.databaseConnection.read { (transaction) in
            identity = CKAccountSignalIdentity.fetchObject(withUniqueID: self.accountKey,
                                                            transaction: transaction)
            signedPreKey = CKSignalSignedPreKey.fetchObject(withUniqueID: self.accountKey,
                                                             transaction: transaction)
        }
        
        guard let signedPreKey = signedPreKey,
              let identity = identity else {
            throw CKBundleError.notFound
        }
        
        // Gather pieces of outgoing bundle
        let preKeys = self.fetchAllPreKeys(false)
        
        let bundle = try CKBundle(identity: identity, signedPreKey: signedPreKey, preKeys: preKeys)
        
        return bundle
    }
    
    fileprivate func fetchDeviceForSignalAddress(_ signalAddress: SignalAddress,
                                                 transaction: YapDatabaseReadTransaction) -> CKDevice? {
        guard let parentEntry = self.parentKeyAndCollectionForSignalAddress(signalAddress,
                                                                            transaction: transaction) else {
            return nil
        }
        
        let deviceNumber = NSNumber(value: signalAddress.deviceId as Int32)
        let deviceYapKey = CKDevice.yapKey(withDeviceId: deviceNumber,
                                           parentKey: parentEntry.key,
                                           parentCollection: parentEntry.collection)
        guard let device = CKDevice.fetchObject(withUniqueID: deviceYapKey,
                                                transaction: transaction) else {
            return nil
        }
        return device
    }
    
    fileprivate func parentKeyAndCollectionForSignalAddress(_ signalAddress: SignalAddress,
                                                            transaction: YapDatabaseReadTransaction) -> (key: String, collection: String)? {
        var parentKey: String?
        var parentCollection: String?
        
        let ourAccount = CKAccount.fetchObject(withUniqueID: self.accountKey, transaction: transaction)
        if ourAccount?.username == signalAddress.name {
            parentKey = self.accountKey
            parentCollection = CKAccount.collection
        } else if let buddy = CKBuddy.fetchBuddy(username: signalAddress.name,
                                                 accountUniqueId: self.accountKey,
                                                 transaction: transaction) {
            parentKey = buddy.uniqueId
            parentCollection = CKBuddy.collection
        }
        
        guard let key = parentKey, let collection = parentCollection else {
            return nil
        }
        
        return (key: key, collection: collection)
    }
}

// MARK: SignalStore
extension CKSignalStorageManager: SignalStore {
    
    // MARK: SignalSessionStore
    public func sessionRecord(for address: SignalAddress) -> Data? {
        let yapKey = CKSignalSession.uniqueKey(forAccountKey: self.accountKey,
                                               name: address.name,
                                               deviceId: address.deviceId)
        var sessionData: Data?
        self.databaseConnection.read { (transaction) in
            sessionData = CKSignalSession.fetchObject(withUniqueID: yapKey,
                                                      transaction: transaction)?.sessionData
        }
        return sessionData
    }
    
    public func storeSessionRecord(_ recordData: Data, for address: SignalAddress) -> Bool {
        guard let session = CKSignalSession(accountKey: self.accountKey,
                                            name: address.name,
                                            deviceId: address.deviceId,
                                            sessionData: recordData) else {
            return false
        }
        self.databaseConnection.readWrite { (transaction) in
            session.save(with: transaction)
        }
        return true
    }
    
    public func sessionRecordExists(for address: SignalAddress) -> Bool {
        return self.sessionRecord(for: address) != nil
    }
    
    public func deleteSessionRecord(for address: SignalAddress) -> Bool {
        let yapKey = CKSignalSession.uniqueKey(forAccountKey: self.accountKey,
                                               name: address.name,
                                               deviceId: address.deviceId)
        self.databaseConnection.readWrite { (transaction) in
            transaction.removeObject(forKey: yapKey, inCollection: CKSignalSession.collection)
        }
        return true
    }
    
    public func allDeviceIds(forAddressName addressName: String) -> [NSNumber] {
        var addresses = [NSNumber]()
        self.databaseConnection.read { (transaction) in
            transaction.enumerateSessions(accountKey: self.accountKey,
                                          signalAddressName: addressName,
                                          block: { session, _ in
                addresses.append(NSNumber(value: session.deviceId as Int32))
            })
        }
        return addresses
    }
    
    public func deleteAllSessions(forAddressName addressName: String) -> Int32 {
        var count: Int32 = 0
        self.databaseConnection.readWrite { transaction in
            var sessionKeys = [String]()
            transaction.enumerateSessions(accountKey: self.accountKey,
                                          signalAddressName: addressName,
                                          block: { session, _ in
                sessionKeys.append(session.uniqueId)
            })
            count = Int32(sessionKeys.count)
            for key in sessionKeys {
                transaction.removeObject(forKey: key, inCollection: CKSignalSession.collection)
            }
        }
        return count
    }
    
    // MARK: SignalPreKeyStore
    public func loadPreKey(withId preKeyId: UInt32) -> Data? {
        var preKeyData: Data?
        self.databaseConnection.read { transaction in
            let yapKey = CKSignalPreKey.uniqueKey(forAccountKey: self.accountKey, keyId: preKeyId)
            if let signedPreKey = CKSignalPreKey.fetchObject(withUniqueID: yapKey, transaction: transaction) {
                preKeyData = signedPreKey.keyData
            }
        }
        return preKeyData
    }
    
    public func storePreKey(_ preKey: Data, preKeyId: UInt32) -> Bool {
        var result = false
        self.databaseConnection.readWrite { (transaction) in
            result = self.storePreKey(preKey, preKeyId: preKeyId, transaction: transaction)
        }
        return result
    }
    
    public func containsPreKey(withId preKeyId: UInt32) -> Bool {
        return self.loadPreKey(withId: preKeyId) != nil
    }
    
    /// Returns true if deleted, false if not found
    public func deletePreKey(withId preKeyId: UInt32) -> Bool {
        return true
    }
    
    // MARK: SignalSignedPreKeyStore
    public func loadSignedPreKey(withId signedPreKeyId: UInt32) -> Data? {
        var preKeyData: Data?
        self.databaseConnection.read { (transaction) in
            if let signedPreKey = CKSignalSignedPreKey.fetchObject(withUniqueID: self.accountKey,
                                                                   transaction: transaction) {
                preKeyData = signedPreKey.keyData
            }
        }
        
        return preKeyData
    }
    
    public func storeSignedPreKey(_ signedPreKey: Data, signedPreKeyId: UInt32) -> Bool {
        guard let signedPreKeyDatabaseObject = CKSignalSignedPreKey(accountKey: self.accountKey,
                                                                    keyId: signedPreKeyId,
                                                                    keyData: signedPreKey) else {
            return false
        }
        self.databaseConnection.readWrite { (transaction) in
            signedPreKeyDatabaseObject.save(with: transaction)
        }
        return true
        
    }
    
    public func containsSignedPreKey(withId signedPreKeyId: UInt32) -> Bool {
        return self.loadSignedPreKey(withId: signedPreKeyId) != nil
    }
    
    public func removeSignedPreKey(withId signedPreKeyId: UInt32) -> Bool {
        self.databaseConnection.readWrite { (transaction) in
            transaction.removeObject(forKey: self.accountKey, inCollection: CKSignalSignedPreKey.collection)
        }
        return true
    }
    
    // MARK: SignalIdentityKeyStore
    public func getIdentityKeyPair() -> SignalIdentityKeyPair {
        if let result = self.accountSignalIdentity() {
            return result.identityKeyPair
        }
        // Generate new identitiy key pair?
        return self.generateNewIdenityKeyPair().identityKeyPair
    }
    
    public func getLocalRegistrationId() -> UInt32 {
        
        if let result = self.accountSignalIdentity() {
            return result.registrationId
        } else {
            // Generate new registration ID?
            return self.generateNewIdenityKeyPair().registrationId
        }
    }
    
    public func saveIdentity(_ address: SignalAddress, identityKey: Data?) -> Bool {
        var result = false
        self.databaseConnection.readWrite { (transaction) in
            if let device = self.fetchDeviceForSignalAddress(address, transaction: transaction) {
                let newDevice = CKDevice(deviceId: device.deviceId,
                                         trustLevel: device.trustLevel,
                                         parentKey: device.parentKey,
                                         parentCollection: device.parentCollection,
                                         publicIdentityKeyData: identityKey,
                                         lastSeenDate: device.lastSeenDate)
                newDevice.save(with: transaction)
                result = true
            } else if let parentEntry = self.parentKeyAndCollectionForSignalAddress(address, transaction: transaction) {
                // See if we have any devices
                var hasDevices = false
                CKDevice.enumerateDevices(forParentKey: parentEntry.key,
                                          collection: parentEntry.collection,
                                          transaction: transaction,
                                          using: { _, stop in
                    hasDevices = true
                    stop.pointee = true
                })
                
                var trustLevel = CKTrustLevel.untrustedNew
                if !hasDevices {
                    // This is the first time we're seeing a device list for this account/buddy so it should be saved as TOFU
                    trustLevel = .trustedTofu
                }
                let deviceIdNumber = NSNumber(value: address.deviceId as Int32)
                let newDevice = CKDevice(deviceId: deviceIdNumber,
                                         trustLevel: trustLevel,
                                         parentKey: parentEntry.key,
                                         parentCollection: parentEntry.collection,
                                         publicIdentityKeyData: identityKey,
                                         lastSeenDate: Date())
                newDevice.save(with: transaction)
                result = true
            }
        }
        return result
    }
    
    // We always return true here because we want Signal to always encrypt and decrypt messages. We deal with trust elsewhere.
    public func isTrustedIdentity(_ address: SignalAddress, identityKey: Data) -> Bool {
        return true
    }
    
    // MARK: SignalSenderKeyStore
    func storeSenderKey(_ senderKey: Data, senderKeyName: SignalSenderKeyName) -> Bool {
        self.databaseConnection.readWrite { (transaction) in
            guard let senderKeyObj = CKSignalSenderKey(accountKey: self.accountKey,
                                                       name: senderKeyName.address.name,
                                                       deviceId: senderKeyName.address.deviceId,
                                                       groupId: senderKeyName.groupId,
                                                       senderKey: senderKey) else {
                return
            }
            senderKeyObj.save(with: transaction)
        }
        return true
    }
    
    func loadSenderKey(for senderKeyName: SignalSenderKeyName) -> Data? {
        var senderKeyData: Data?
        self.databaseConnection.read { (transaction) in
            let yapKey = CKSignalSenderKey.uniqueKey(fromAccountKey: self.accountKey,
                                                     name: senderKeyName.address.name,
                                                     deviceId: senderKeyName.address.deviceId,
                                                     groupId: senderKeyName.groupId)
            let senderKey = CKSignalSenderKey.fetchObject(withUniqueID: yapKey, transaction: transaction)
            senderKeyData = senderKey?.senderKey
        }
        return senderKeyData
    }
    
    public func senderKeyExists(for senderKeyName: SignalSenderKeyName) -> Bool {
        return self.loadSenderKey(for: senderKeyName) != nil
    }
}

extension CKSignalSession {
    /// "\(accountKey)-\(name)", only used for SecondaryIndex lookups
    public var sessionKey: String {
        return CKSignalSession.sessionKey(accountKey: accountKey, name: name)
    }
    
    /// "\(accountKey)-\(name)", only used for SecondaryIndex lookups
    public static func sessionKey(accountKey: String, name: String) -> String {
        return "\(accountKey)-\(name)"
    }
}
