//
//  SecondaryIndexes.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 10/27/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

//swiftlint:disable inclusive_language
import Foundation
import YapDatabase

extension YapDatabaseSecondaryIndexOptions {
    convenience init(whitelist: [String]) {
        let set = Set(whitelist)
        let whitelist = YapWhitelistBlacklist(whitelist: set)
        self.init()
        self.allowedCollections = whitelist
    }
}

extension YapDatabaseSecondaryIndex {
    @objc public static var buddyIndex: YapDatabaseSecondaryIndex {
        let columns: [String:YapDatabaseSecondaryIndexType] = [
            BuddyIndexColumnName.accountKey: .text,
            BuddyIndexColumnName.username: .text
        ]
        let setup = YapDatabaseSecondaryIndexSetup(capacity: UInt(columns.count))
        columns.forEach { (key, value) in
            setup.addColumn(key, with: value)
        }
        let handler = YapDatabaseSecondaryIndexHandler.withObjectBlock { transaction, dict, collection, key, object in
            guard let buddy = object as? CKBuddy else {
                return
            }
            dict[BuddyIndexColumnName.accountKey] = buddy.accountUniqueId
            dict[BuddyIndexColumnName.username] = buddy.username
        }
        let options = YapDatabaseSecondaryIndexOptions(whitelist: [CKBuddy.collection])
        let secondaryIndex = YapDatabaseSecondaryIndex(setup: setup, handler: handler, versionTag: "2", options: options)
        return secondaryIndex
    }
    
    @objc public static var signalIndex: YapDatabaseSecondaryIndex {
        let columns: [String: YapDatabaseSecondaryIndexType] = [
            SignalIndexColumnName.session: .text,
            SignalIndexColumnName.preKeyId: .integer,
            SignalIndexColumnName.preKeyAccountKey: .text,
            SignalIndexColumnName.testModelKey: .text
        ]
        let setup = YapDatabaseSecondaryIndexSetup(capacity: UInt(columns.count))
        columns.forEach { (key, value) in
            setup.addColumn(key, with: value)
        }
        
        let handler = YapDatabaseSecondaryIndexHandler.withObjectBlock { transaction, dict, collection, key, object in
            if let session = object as? CKSignalSession {
                if session.name.count > 0 {
                    dict[SignalIndexColumnName.session] = session.sessionKey
                }
            } else if let preKey = object as? CKSignalPreKey {
                dict[SignalIndexColumnName.preKeyId] = preKey.keyId
                if preKey.accountKey.count > 0 {
                    dict[SignalIndexColumnName.preKeyAccountKey] = preKey.accountKey
                }
            }
        }
        let options = YapDatabaseSecondaryIndexOptions(whitelist: [CKSignalPreKey.collection, CKSignalSession.collection])
        let secondaryIndex = YapDatabaseSecondaryIndex(setup: setup, handler: handler, versionTag: "6", options: options)
        return secondaryIndex
    }
}

extension CKBuddy {
    /// This function should only be used when the secondary index is not ready
    private static func slowLookup(username: String,
                                   accountUniqueId: String,
                                   transaction: YapDatabaseReadTransaction) -> CKBuddy? {
        NSLog("WARN: Using slow O(n) lookup for CKBuddy: \(username)")
        var buddy: CKBuddy?
//        transaction.iterateKeysAndObjects(inCollection: CKBuddy.collection) { _, potentialMatch: CKBuddy, stop in
//            if potentialMatch.username == username {
//                buddy = potentialMatch
//                stop = true
//            }
//        }
        return buddy
    }
    
    /// Fetch buddy matching JID using secondary index
    @objc public static func fetchBuddy(username: String,
                                        accountUniqueId: String,
                                        transaction: YapDatabaseReadTransaction) -> CKBuddy? {
        guard let indexTransaction = transaction.ext(SecondaryIndexName.buddy) as? YapDatabaseSecondaryIndexTransaction else {
            NSLog("Error looking up CKBuddy via SecondaryIndex: Extension not ready.")
            return self.slowLookup(username: username, accountUniqueId: accountUniqueId, transaction: transaction)
        }
        let queryString = "Where \(BuddyIndexColumnName.accountKey) == ? AND \(BuddyIndexColumnName.username) == ?"
        let query = YapDatabaseQuery(string: queryString, parameters: [accountUniqueId, username])
        
        var matchingBuddies: [CKBuddy] = []
        let success = indexTransaction.iterateKeysAndObjects(matching: query) { _, _, object, _ in
            if let matchingBuddy = object as? CKBuddy {
                matchingBuddies.append(matchingBuddy)
            }
        }
        if !success {
            NSLog("Error looking up CKBuddy with query \(query) \(username) \(accountUniqueId)")
            return nil
        }
        if matchingBuddies.count > 1 {
            NSLog("WARN: More than one CKBuddy matching query \(query) \(username) \(accountUniqueId): \(matchingBuddies.count)")
        }
        return matchingBuddies.first
    }
}

// MARK: - Constants

/// YapDatabase extension names for Secondary Indexes
@objc public class SecondaryIndexName: NSObject {
    @objc public static let messages = "CKMessagesSecondaryIndex"
    @objc public static let signal = "CKYapDatabseMessageIdSecondaryIndexExtension"
    @objc public static let roomOccupants = "SecondaryIndexName_roomOccupantIndex"
    @objc public static let buddy = "SecondaryIndexName_buddy"
    @objc public static let mediaItems = "SecondaryIndexName_mediaItems"
}

@objc public class BuddyIndexColumnName: NSObject {
    @objc public static let accountKey = "BuddyIndexColumnName_accountKey"
    @objc public static let username = "BuddyIndexColumnName_username"
}

@objc public class MessageIndexColumnName: NSObject {
    @objc public static let messageKey = "CKYapDatabaseMessageIdSecondaryIndexColumnName"
    @objc public static let remoteMessageId = "CKYapDatabaseRemoteMessageIdSecondaryIndexColumnName"
    @objc public static let threadId = "CKYapDatabaseMessageThreadIdSecondaryIndexColumnName"
    @objc public static let isMessageRead = "CKYapDatabaseUnreadMessageSecondaryIndexColumnName"
    
    /// XEP-0359 origin-id
    @objc public static let originId = "SecondaryIndexNameOriginId"
    /// XEP-0359 stanza-id
    @objc public static let stanzaId = "SecondaryIndexNameStanzaId"
}

@objc public class RoomOccupantIndexColumnName: NSObject {
    /// jids
    @objc public static let jid = "CKYapDatabaseRoomOccupantJidSecondaryIndexColumnName"
    @objc public static let realJID = "RoomOccupantIndexColumnName_realJID"
    @objc public static let roomUniqueId = "RoomOccupantIndexColumnName_roomUniqueId"
    @objc public static let buddyUniqueId = "RoomOccupantIndexColumnName_buddyUniqueId"
}

@objc public class SignalIndexColumnName: NSObject {
    @objc public static let session = "CKYapDatabaseSignalSessionSecondaryIndexColumnName"
    @objc public static let preKeyId = "CKYapDatabaseSignalPreKeyIdSecondaryIndexColumnName"
    @objc public static let preKeyAccountKey = "CKYapDatabaseSignalPreKeyAccountKeySecondaryIndexColumnName"
    @objc public static let testModelKey = "testModelKey"
}

@objc public class MediaItemIndexColumnName: NSObject {
    @objc public static let mediaItemId = "MediaItemIndexColumnName_mediaItemId"
    @objc public static let transferProgress = "MediaItemIndexColumnName_transferProgress"
    @objc public static let isIncoming = "MediaItemIndexColumnName_isIncoming"
}
