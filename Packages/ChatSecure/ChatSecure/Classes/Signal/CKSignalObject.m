//
//  CKSignalObject.m
//  ClearKeep
//
//  Created by VietAnh on 10/30/20.
//

#import "CKSignalObject.h"

@implementation CKSignalObject

/** Make sure if the account is deleted all the signal objects associated with that account
 * are also removed from the database
 */
- (nullable NSArray<YapDatabaseRelationshipEdge *> *)yapDatabaseRelationshipEdges
{
//    YapDatabaseRelationshipEdge *accountEdge = [[YapDatabaseRelationshipEdge alloc] initWithName:@"" destinationKey:self.accountKey collection:[OTRAccount collection] nodeDeleteRules:YDB_DeleteSourceIfDestinationDeleted];
//    if (accountEdge) {
//        return @[accountEdge];
//    }
    return nil;
}

@end
