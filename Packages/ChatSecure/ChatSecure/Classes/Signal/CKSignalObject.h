//
//  CKSignalObject.h
//  ClearKeep
//
//  Created by VietAnh on 10/30/20.
//

#import "CKYapDatabaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CKSignalObject : CKYapDatabaseObject <YapDatabaseRelationshipNode>

@property (nonnull, strong) NSString *accountKey;

@end

NS_ASSUME_NONNULL_END
