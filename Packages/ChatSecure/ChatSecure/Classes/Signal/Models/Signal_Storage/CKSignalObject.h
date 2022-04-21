//
//  CKSignalObject.h
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKYapDatabaseObject.h"
@import YapDatabase;

NS_ASSUME_NONNULL_BEGIN

@interface CKSignalObject : CKYapDatabaseObject <YapDatabaseRelationshipNode>

@property (nonnull, strong) NSString *accountKey;

@end

NS_ASSUME_NONNULL_END
