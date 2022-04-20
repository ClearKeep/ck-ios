//
//  CKAccount.m
//  ClearKeep
//
//  Created by Luan Nguyen on 3/28/20.
//  Copyright (c) 2020 Luan Nguyen. All rights reserved.
//

#import "CKAccount.h"

#import "CKDatabaseManager.h"
@import YapDatabase;

@interface CKAccount ()
@end

@implementation CKAccount
@synthesize accountType = _accountType;

- (nullable instancetype)initWithUsername:(NSString*)username
                                 deviceId:(int32_t) deviceId
                              accountType:(CKAccountType)accountType {
    NSParameterAssert(username != nil);
    if (!username) {
        return nil;
    }
    if (self = [super init]) {
        _username = [username copy];
        _accountType = accountType;
        _deviceId = deviceId;
    }
    return self;
}

- (UIImage *)accountImage
{
    return nil;
}

- (Class)protocolClass {
    NSAssert(NO, @"Must implement in subclass.");
    return nil;
}

+ (nullable instancetype) fetchObjectWithUniqueID:(NSString *)uniqueID transaction:(YapDatabaseReadTransaction *)transaction {
    if (!uniqueID || !transaction) { return nil; }
    CKAccount *account = (CKAccount*)[super fetchObjectWithUniqueID:uniqueID transaction:transaction];
    if (!account.username.length) {
        return nil;
    }
    return account;
}


#pragma mark NSCoding

#pragma - mark Class Methods

+ (nullable instancetype)accountWithUsername:(NSString*)username
                                    deviceId:(int32_t) deviceId
                                 accountType:(CKAccountType)accountType
{
    NSParameterAssert(username != nil);
    if (!username) { return nil; }
    CKAccount *account = [[CKAccount alloc] initWithUsername:username deviceId: deviceId accountType:accountType];
    return account;
}

+ (NSArray *)allAccountsWithUsername:(NSString *)username transaction:(YapDatabaseReadTransaction*)transaction
{
    __block NSMutableArray *accountsArray = [NSMutableArray array];
    [transaction enumerateKeysAndObjectsInCollection:[CKAccount collection] usingBlock:^(NSString *key, CKAccount *account, BOOL *stop) {
        if ([account isKindOfClass:[CKAccount class]] && [account.username isEqualToString:username]) {
            [accountsArray addObject:account];
        }
    }];
    if (accountsArray.count > 1) {
        NSLog(@"More than one account matching username! %@ %@", username, accountsArray);
    }
    return accountsArray;
}

+ (NSUInteger) numberOfAccountsWithTransaction:(YapDatabaseReadTransaction*)transaction {
    return [transaction numberOfKeysInCollection:[CKAccount collection]];
}

+ (NSArray <CKAccount *>*)allAccountsWithTransaction:(YapDatabaseReadTransaction*)transaction
{
    NSMutableArray <CKAccount *>*accounts = [NSMutableArray array];
    NSString *collection = [CKAccount collection];
    NSArray <NSString*>*allAccountKeys = [transaction allKeysInCollection:collection];
    [allAccountKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = [transaction objectForKey:key inCollection:collection];
        if (object && [object isKindOfClass:[CKAccount class]]) {
            [accounts addObject:object];
        }
    }];
    
    return accounts;
    
}

+ (NSUInteger)removeAllAccountsOfType:(CKAccountType)accountType inTransaction:(YapDatabaseReadWriteTransaction *)transaction
{
    NSMutableArray *keys = [NSMutableArray array];
    [transaction enumerateKeysAndObjectsInCollection:[self collection] usingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([object isKindOfClass:[self class]]) {
            CKAccount *account = (CKAccount *)object;
            
            if (account.accountType == accountType) {
                [keys addObject:account.uniqueId];
            }
        }
    }];
    
    [transaction removeObjectsForKeys:keys inCollection:[self collection]];
    return [keys count];
}

+ (NSUInteger)removeAllAccountsInTransaction:(YapDatabaseReadWriteTransaction *)transaction
{
    NSMutableArray *keys = [NSMutableArray array];
    [transaction enumerateKeysAndObjectsInCollection:[self collection] usingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([object isKindOfClass:[self class]]) {
            CKAccount *account = (CKAccount *)object;
            [keys addObject:account.uniqueId];
        }
    }];
    
    [transaction removeObjectsForKeys:keys inCollection:[self collection]];
    return [keys count];
}

+ (NSInteger)removeAllAccountsWithUsername:(NSString *)username transaction:(YapDatabaseReadWriteTransaction*)transaction {
    NSMutableArray *keys = [NSMutableArray array];
    [transaction enumerateKeysAndObjectsInCollection:[self collection] usingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([object isKindOfClass:[self class]]) {
            CKAccount *account = (CKAccount *)object;
            
            if ([account.username isEqualToString:username]) {
                [keys addObject:account.uniqueId];
            }
        }
    }];

    [transaction removeObjectsForKeys:keys inCollection:[self collection]];
    return [keys count];
}


// See MTLModel+NSCoding.h
// This helps enforce that only the properties keys that we
// desire will be encoded. Be careful to ensure that values
// that should be stored in the keychain don't accidentally
// get serialized!
+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSMutableDictionary *behaviors = [NSMutableDictionary dictionaryWithDictionary:[super encodingBehaviorsByPropertyKey]];
    return behaviors;
}

+ (MTLPropertyStorage)storageBehaviorForPropertyWithKey:(NSString *)propertyKey {
    return [super storageBehaviorForPropertyWithKey:propertyKey];
}

@end
