//
//  CKSignalObject.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalObject.h"
#import "CKAccount.h"
#import <ChatSecure/ChatSecure-Swift.h>

@implementation CKSignalObject

/** Make sure if the account is deleted all the signal objects associated with that account 
 * are also removed from the database 
 */
- (nullable NSArray<YapDatabaseRelationshipEdge *> *)yapDatabaseRelationshipEdges
{
    YapDatabaseRelationshipEdge *accountEdge = [[YapDatabaseRelationshipEdge alloc] initWithName:@"" destinationKey:self.accountKey collection:[CKAccount collection] nodeDeleteRules:YDB_DeleteSourceIfDestinationDeleted];
    if (accountEdge) {
        return @[accountEdge];
    }
    return nil;
}

@end
