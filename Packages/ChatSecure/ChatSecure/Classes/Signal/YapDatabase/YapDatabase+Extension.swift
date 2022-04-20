//
//  YapDatabse+ChatSecure.swift
//  ClearKeep
//
//  Created by Luan Nguyen on 11/02/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

//swiftlint:disable inclusive_language

import Foundation
import YapDatabase

@objc public extension CKDatabaseManager {
    var connections: DatabaseConnections? {
        guard let ui = uiConnection,
              let read = readConnection,
              let write = writeConnection,
              let long = longLivedReadOnlyConnection else {
            return nil
        }
        return DatabaseConnections(ui: ui, read: read, write: write, longLivedRead: long)
    }
}

/// This class holds shared references to commonly-needed Yap database connections
@objcMembers
public class DatabaseConnections: NSObject {
    
    /// User interface / synchronous main-thread reads only!
    public let ui: YapDatabaseConnection
    /// Background / async reads only! Not for use in main thread / UI code.
    public let read: YapDatabaseConnection
    /// Background writes only! Never use this synchronously from the main thread!
    public let write: YapDatabaseConnection
    /// This is only to be used by the YapViewHandler for main thread reads only!
    public let longLivedRead: YapDatabaseConnection
    
    init(ui: YapDatabaseConnection,
         read: YapDatabaseConnection,
         write: YapDatabaseConnection,
         longLivedRead: YapDatabaseConnection) {
        self.ui = ui
        self.read = read
        self.write = write
        self.longLivedRead = longLivedRead
    }
}

extension YapDatabase {
    @objc func asyncRegisterView(_ grouping: YapDatabaseViewGrouping,
                                 sorting: YapDatabaseViewSorting,
                                 version: String,
                                 whiteList: Set<String>,
                                 name: DatabaseExtensionName,
                                 completionQueue: DispatchQueue?,
                                 completionBlock: ((Bool) -> Void)?) {
        
        if self.registeredExtension(name.name()) != nil {
            let queue: DispatchQueue = completionQueue ?? DispatchQueue.main
            if let block = completionBlock {
                queue.async(execute: { () -> Void in
                    block(true)
                })
            }
            return
        }
        
        let options = YapDatabaseViewOptions()
        options.allowedCollections = YapWhitelistBlacklist(whitelist: whiteList)
        let view = YapDatabaseAutoView(grouping: grouping, sorting: sorting, versionTag: version, options: options)
        self.asyncRegister(view, withName: name.name(), completionQueue: completionQueue, completionBlock: completionBlock)
    }
}
