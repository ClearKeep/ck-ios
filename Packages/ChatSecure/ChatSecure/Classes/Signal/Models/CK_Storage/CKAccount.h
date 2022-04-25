//
//  CKAccount.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/28/20.
//  Copyright (c) 2020 Luan Nguyen. All rights reserved.
//
@import UIKit;
#import "CKYapDatabaseObject.h"

typedef NS_ENUM(int, CKAccountType) {
    CKAccountTypeNone        = 0,
    CKAccountTypeFacebook    = 1, // deprecated
    CKAccountTypeGoogleTalk  = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface CKAccount : CKYapDatabaseObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, readonly) int32_t deviceId;
@property (nonatomic, readonly) CKAccountType accountType;

/** Whether or not user would like to auto fetch media messages */
@property (nonatomic, readwrite) BOOL disableAutomaticURLFetching;


/** Will return nil if accountType does not match class type. @see accountClassForAccountType: */
- (nullable instancetype)initWithUsername:(NSString*)username
                                 deviceId:(int32_t) deviceId
                              accountType:(CKAccountType)accountType NS_DESIGNATED_INITIALIZER;

/** Will return a concrete subclass of CKAccount. @see accountClassForAccountType: */
+ (nullable __kindof CKAccount*)accountWithUsername:(NSString*)username
                                           deviceId:(int32_t) deviceId
                                         accountType:(CKAccountType)accountType;

/** Not available, use designated initializer */
- (instancetype) init NS_UNAVAILABLE;

+ (NSArray <CKAccount *>*)allAccountsWithUsername:(NSString *)username transaction:(YapDatabaseReadTransaction*)transaction;
+ (NSArray <CKAccount *>*)allAccountsWithTransaction:(YapDatabaseReadTransaction*)transaction;
+ (NSUInteger) numberOfAccountsWithTransaction:(YapDatabaseReadTransaction*)transaction;

/**
 Remove all accounts with account type using a read/write transaction
 
 @param accountType the account type to remove
 @param transaction a readwrite yap transaction
 @return the number of accounts removed
 */
+ (NSUInteger)removeAllAccountsInTransaction:(YapDatabaseReadWriteTransaction *)transaction;
+ (NSUInteger)removeAllAccountsOfType:(CKAccountType)accountType inTransaction:(YapDatabaseReadWriteTransaction *)transaction;
+ (NSInteger)removeAllAccountsWithUsername:(NSString *)username transaction:(YapDatabaseReadWriteTransaction*)transaction;

@end
NS_ASSUME_NONNULL_END
