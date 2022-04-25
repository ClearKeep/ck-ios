//
//  CKSignalPreKey.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CKSignalPreKey : CKSignalObject

@property (nonatomic) uint32_t keyId;
@property (nonatomic, strong, nullable) NSData *keyData;

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey keyId:(uint32_t)keyId keyData:(nullable NSData *)keyData;

+ (NSString *)uniqueKeyForAccountKey:(NSString *)accountKey keyId:(uint32_t)keyId;

@end

NS_ASSUME_NONNULL_END
