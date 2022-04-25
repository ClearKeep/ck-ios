//
//  CKBuddy.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/28/20.
//  Copyright (c) 2020 Luan Nguyen. All rights reserved.
//

#import "CKBuddy.h"
#import "CKAccount.h"
#import "CKDevice.h"
#import <ChatSecure/ChatSecure-Swift.h>

@import YapDatabase;

@implementation CKBuddy

- (CKAccount*)accountWithTransaction:(YapDatabaseReadTransaction *)transaction
{
    return [CKAccount fetchObjectWithUniqueID:self.accountUniqueId transaction:transaction];
}

+ (nullable instancetype) fetchObjectWithUniqueID:(NSString *)uniqueID transaction:(YapDatabaseReadTransaction *)transaction {
    CKBuddy *buddy = (CKBuddy*)[super fetchObjectWithUniqueID:uniqueID transaction:transaction];
    if (!buddy.username.length) {
        return nil;
    }
    return buddy;
}

- (NSArray<CKDevice*>*)CKDevicesWithTransaction:(YapDatabaseReadTransaction*)transaction {
    NSParameterAssert(transaction);
    if (!transaction) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Missing transaction for bestTransportSecurityWithTransaction!" userInfo:nil];
    }
    NSArray <CKDevice *>*devices = [CKDevice allDevicesForParentKey:self.uniqueId
                                                                     collection:[[self class] collection]
                                                                    transaction:transaction];
    return devices;
}


#pragma - mark YapDatabaseRelationshipNode
- (NSArray *)yapDatabaseRelationshipEdges
{
    NSArray *edges = nil;
    if (self.accountUniqueId) {
        NSString *edgeName = [YapDatabaseConstants edgeName:RelationshipEdgeNameBuddyAccountEdgeName];
        YapDatabaseRelationshipEdge *accountEdge = [YapDatabaseRelationshipEdge edgeWithName:edgeName
                                                                              destinationKey:self.accountUniqueId
                                                                                  collection:[CKAccount collection]
                                                                             nodeDeleteRules:YDB_DeleteSourceIfDestinationDeleted];
        edges = @[accountEdge];
    }
    
    
    return edges;
}

#pragma - mark Class Methods

#pragma mark Disable Mantle Storage of Dynamic Properties

+ (NSSet<NSString*>*) excludedProperties {
    static NSSet<NSString*>* excludedProperties = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        excludedProperties = [NSSet setWithArray:@[]];
    });
    return excludedProperties;
}

// See MTLModel+NSCoding.h
// This helps enforce that only the properties keys that we
// desire will be encoded. Be careful to ensure that values
// that should be stored in the keychain don't accidentally
// get serialized!
+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSMutableDictionary *behaviors = [NSMutableDictionary dictionaryWithDictionary:[super encodingBehaviorsByPropertyKey]];
    NSSet<NSString*> *excludedProperties = [self excludedProperties];
    [excludedProperties enumerateObjectsUsingBlock:^(NSString * _Nonnull selector, BOOL * _Nonnull stop) {
        [behaviors setObject:@(MTLModelEncodingBehaviorExcluded) forKey:selector];
    }];
    return behaviors;
}

+ (MTLPropertyStorage)storageBehaviorForPropertyWithKey:(NSString *)propertyKey {
    NSSet<NSString*> *excludedProperties = [self excludedProperties];
    if ([excludedProperties containsObject:propertyKey]) {
        return MTLPropertyStorageNone;
    }
    return [super storageBehaviorForPropertyWithKey:propertyKey];
}

@end
