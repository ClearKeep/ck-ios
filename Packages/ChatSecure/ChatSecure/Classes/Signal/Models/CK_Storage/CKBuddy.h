//
//  CKBuddy.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/28/20.
//  Copyright (c) 2020 Luan Nguyen. All rights reserved.
//

#import "CKYapDatabaseObject.h"
@import UIKit;

typedef NS_ENUM(NSUInteger, CKChatState) {
    CKChatStateUnknown   = 0,
    CKChatStateActive    = 1,
    CKChatStateComposing = 2,
    CKChatStatePaused    = 3,
    CKChatStateInactive  = 4,
    CKChatStateGone      = 5
};

/** These are the preferences for a buddy on how to send a message. Related CKMessageTransportSecurity*/
typedef NS_ENUM(NSUInteger, CKSessionSecurity) {
    CKSessionSecurityBestAvailable = 0,
    CKSessionSecurityPlaintextOnly = 1,
    CKSessionSecurityPlaintextWithCK = 2,
    CKSessionSecurityCK = 3,
    CKSessionSecurityOMEMO = 4,
    /** This is deprecated, this option will now only use OMEMO */
    CKSessionSecurityOMEMOandCK = 5
};


@class CKAccount, CKMessage;


@interface CKBuddy : CKYapDatabaseObject <YapDatabaseRelationshipNode>

@property (nonatomic, strong, nonnull) NSString *username;
@property (nonatomic, strong, nonnull) NSString *accountUniqueId;

- (nullable CKAccount*)accountWithTransaction:(nonnull YapDatabaseReadTransaction *)transaction;

/** Excluded properties for Mantle */
+ (nonnull NSSet<NSString*>*) excludedProperties;

@end
