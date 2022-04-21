//
//  CKSignalSignedPreKey.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalSignedPreKey.h"
#import "CKAccount.h"
#import <ChatSecure/ChatSecure-Swift.h>

@implementation CKSignalSignedPreKey

- (instancetype) initWithAccountKey:(NSString *)accountKey keyId:(uint32_t)keyId keyData:(NSData *)keyData
{
    if (self = [super initWithUniqueId:accountKey]) {
        self.accountKey = accountKey;
        self.keyId = keyId;
        self.keyData = keyData;
    }
    return self;
}


- (nullable NSArray<YapDatabaseRelationshipEdge *> *)yapDatabaseRelationshipEdges
{
    NSString *edgeName = [YapDatabaseConstants edgeName:RelationshipEdgeNameSignalSignedPreKey];
    YapDatabaseRelationshipEdge *edge = [YapDatabaseRelationshipEdge edgeWithName:edgeName destinationKey:self.accountKey collection:[CKAccount collection] nodeDeleteRules:YDB_DeleteSourceIfDestinationDeleted];
    if (edge) {
        return @[edge];
    }
    return nil;
}

@end
