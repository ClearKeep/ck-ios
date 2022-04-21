//
//  CKSignalSignedPreKey.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalObject.h"
@import YapDatabase;

NS_ASSUME_NONNULL_BEGIN

@interface CKSignalSignedPreKey : CKSignalObject <YapDatabaseRelationshipNode>

@property (nonatomic) uint32_t keyId;
@property (nonatomic, strong) NSData *keyData;

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey keyId:(uint32_t)keyId keyData:(NSData *)keyData;

@end

NS_ASSUME_NONNULL_END
