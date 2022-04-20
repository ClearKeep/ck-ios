//
//  CKDevice.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/14/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKYapDatabaseObject.h"

/*
 *
 */
typedef NS_ENUM(NSUInteger, CKTrustLevel) {
    /// new device seen
    CKTrustLevelUntrustedNew = 0,
    /// device manually untrusted
    CKTrustLevelUntrusted    = 1,
    /// device trusted on first use
    CKTrustLevelTrustedTofu  = 2,
    /// device manually trusted by user
    CKTrustLevelTrustedUser  = 3,
    /** If the device has been removed from the server */
    CKTrustLevelRemoved  = 4,
};

NS_ASSUME_NONNULL_BEGIN

/// Also see CKDevice.swift
@interface CKDevice : CKYapDatabaseObject <YapDatabaseRelationshipNode>

@property (nonatomic, strong, readonly) NSString *parentKey;
@property (nonatomic, strong, readonly) NSString *parentCollection;

@property (nonatomic, strong, readonly) NSNumber *deviceId;

@property (nonatomic, strong, readwrite, nullable) NSData *publicIdentityKeyData;

// First Time seing device list all trusted
// Any new devices after that are not trusted and require user input
@property (nonatomic, readwrite) CKTrustLevel trustLevel;

@property (nonatomic, strong, readwrite) NSDate *lastSeenDate;

/** (CKTrustLevelTrustedTofu || CKTrustLevelTrustedUser) && !isExpired */
- (BOOL) isTrusted;

/** if lastSeenDate is > 30 days */
- (BOOL) isExpired;

/** if lastSeenDate is nil, it is set to NSDate.date */
- (instancetype) initWithDeviceId:(NSNumber *)deviceId
                                trustLevel:(CKTrustLevel)trustLevel
                                 parentKey:(NSString *)parentKey
                          parentCollection:(NSString *)parentCollection
                     publicIdentityKeyData:(nullable NSData *)publicIdentityKeyData
                            lastSeenDate:(nullable NSDate *)lastSeenDate;


+ (void)enumerateDevicesForParentKey:(NSString *)key
                          collection:(NSString *)collection
                         transaction:(YapDatabaseReadTransaction *)transaction
                          usingBlock:(void (^)(CKDevice * _Nonnull device, BOOL * _Nonnull stop))block;

+ (NSArray <CKDevice *>*)allDevicesForParentKey:(NSString *)key
                                           collection:(NSString *)collection
                                          transaction:(YapDatabaseReadTransaction *)transaction;

/** trustedOnly=true returns only trusted devices, otherwise it returns all devices */
+ (NSArray <CKDevice *>*)allDevicesForParentKey:(NSString *)key
                                           collection:(NSString *)collection
                                          trustedOnly:(BOOL)trustedOnly
                                          transaction:(YapDatabaseReadTransaction *)transaction;

+ (NSString *)yapKeyWithDeviceId:(NSNumber *)deviceId
                       parentKey:(NSString *)parentKey
                parentCollection:(NSString *)parentCollection;

@end

NS_ASSUME_NONNULL_END
