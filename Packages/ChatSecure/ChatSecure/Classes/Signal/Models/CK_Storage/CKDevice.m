//
//  CKDevice.m
//  ClearKeep
//
//  Created by Luan Nguyen on 9/14/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKDevice.h"
#import "CKDatabaseManager.h"

@implementation CKDevice

- (instancetype) initWithDeviceId:(NSNumber *)deviceId trustLevel:(CKTrustLevel)trustLevel parentKey:(NSString *)parentKey parentCollection:(NSString *)parentCollection publicIdentityKeyData:(nullable NSData *)publicIdentityKeyData lastSeenDate:(nullable NSDate *)lastSeenDate
{
    if (self = [super init]) {
        _deviceId = deviceId;
        _parentKey = parentKey;
        _parentCollection = parentCollection;
        _trustLevel = trustLevel;
        _publicIdentityKeyData = publicIdentityKeyData;
        if (!_lastSeenDate) {
            _lastSeenDate = [NSDate date];
        }
    }
    return self;
}

- (NSString *)uniqueId {
    return [[self class] yapKeyWithDeviceId:self.deviceId parentKey:self.parentKey parentCollection:self.parentCollection];
}

+ (NSUInteger) modelVersion {
    return 2;
}

+ (NSString*) collection {
    // for historical purposes
    return @"CKDevice";
}

/** (CKTrustLevelTrustedTofu || CKTrustLevelTrustedUser) && !isExpired */
- (BOOL) isTrusted {
    return (_trustLevel == CKTrustLevelTrustedTofu || _trustLevel == CKTrustLevelTrustedUser) && ![self isExpired];
}

/** if lastSeenDate is > 30 days, but not if ALL keys are expired and this is the one last seen */
- (BOOL) isExpired {
    if ([self _isExpired]) {
        if (self.lastSeenDate && [CKDevice isLastSeenExpiredDevice:self]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

/** if lastSeenDate is > 30 days */
- (BOOL) _isExpired {
    if (!self.lastSeenDate) {
        return YES;
    }
    NSTimeInterval span = [[NSDate date] timeIntervalSinceDate:self.lastSeenDate];
    NSTimeInterval thirtyDays = 86400 * 30;
    if (span > thirtyDays) {
        return YES;
    }
    return NO;
}

/** If ALL devices are considered expired, return TRUE if device is the one that was last seen of them all. Kind of hackish, but would have required major refactoring. */
+ (BOOL) isLastSeenExpiredDevice:(CKDevice *)device {
    __block NSArray <CKDevice *>* devices = nil;
//    [[CKDatabaseManager.shared connections].read readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
//        devices = [CKDevice allDevicesForParentKey:device.parentKey collection:device.parentCollection transaction:transaction];
//    }];
//    if (devices != nil && [devices count] > 0) {
//        NSArray *sortedDevices = [devices sortedArrayUsingComparator:^NSComparisonResult(CKDevice * _Nonnull obj1, CKDevice * _Nonnull obj2) {
//            NSDate *date1 = [NSDate distantPast];
//            NSDate *date2 = [NSDate distantPast];
//            if (obj1.lastSeenDate) {
//                date1 = obj1.lastSeenDate;
//            }
//            if (obj2.lastSeenDate) {
//                date2 = obj2.lastSeenDate;
//            }
//            // Latest first
//            return [date2 compare:date1];
//        }];
//        CKDevice *first = [sortedDevices firstObject];
//        
//        // They are ordered by date, so if "first" _isExpired they all are!
//        if (first.lastSeenDate && [first _isExpired] && [device.uniqueId isEqualToString:first.uniqueId]) {
//            return YES;
//        }
//    }
    return NO;
}

+ (void)enumerateDevicesForParentKey:(NSString *)key collection:(NSString *)collection transaction:(YapDatabaseReadTransaction *)transaction usingBlock:(void (^)(CKDevice * _Nonnull device, BOOL * _Nonnull stop))block
{
    NSString *extensionName = @"DatabaseExtensionNameRelationshipExtensionName";
    NSString *edgeName = @"RelationshipEdgeNameCKDeviceEdgeName";
    
    [((YapDatabaseRelationshipTransaction *)[transaction ext:extensionName]) enumerateEdgesWithName:edgeName destinationKey:key collection:collection usingBlock:^(YapDatabaseRelationshipEdge * _Nonnull edge, BOOL * _Nonnull stop) {
        
        id possibleDevice = [transaction objectForKey:edge.sourceKey inCollection:edge.sourceCollection];
        if (possibleDevice != nil && [possibleDevice isKindOfClass:[CKDevice class] ]) {
            CKDevice *device = possibleDevice;
            block(device,stop);
        }
    }];
}

+ (NSArray <CKDevice *>*)allDevicesForParentKey:(NSString *)key collection:(NSString *)collection transaction:(YapDatabaseReadTransaction *)transaction {
    return [self allDevicesForParentKey:key collection:collection trustedOnly:NO transaction:transaction];
}

+ (NSArray <CKDevice *>*)allDevicesForParentKey:(NSString *)key collection:(NSString *)collection trustedOnly:(BOOL)trustedOnly transaction:(YapDatabaseReadTransaction *)transaction {
    NSMutableArray <CKDevice *>*devices = [[NSMutableArray alloc] init];
    [self enumerateDevicesForParentKey:key collection:collection transaction:transaction usingBlock:^(CKDevice * _Nonnull device, BOOL * _Nonnull stop) {
        if (trustedOnly && device.isTrusted) {
            [devices addObject:device];
        } else if (!trustedOnly) {
            [devices addObject:device];
        }
        
    }];
    return devices;
}

#pragma MARK YapDatabaseRelationshipNode Methods

- (nullable NSArray<YapDatabaseRelationshipEdge *> *)yapDatabaseRelationshipEdges
{
    NSString *edgeName = @"RelationshipEdgeNameCKDeviceEdgeName";
    YapDatabaseRelationshipEdge *edge = [YapDatabaseRelationshipEdge edgeWithName:edgeName destinationKey:self.parentKey collection:self.parentCollection nodeDeleteRules:YDB_DeleteSourceIfDestinationDeleted];
    if (edge) {
        return @[edge];
    }
    return nil;
}

#pragma MARK Class Methods

+ (NSString *)yapKeyWithDeviceId:(NSNumber *)deviceId parentKey:(NSString *)parentKey parentCollection:(NSString *)parentCollection
{
    return [NSString stringWithFormat:@"%@-%@-%@",deviceId,parentKey,parentCollection];
}

@end
