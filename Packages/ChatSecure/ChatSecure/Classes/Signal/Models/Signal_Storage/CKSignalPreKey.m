//
//  CKSignalPreKey.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalPreKey.h"

@implementation CKSignalPreKey

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey keyId:(uint32_t)keyId keyData:(NSData *)keyData {
    NSString *yapKey = [[self class] uniqueKeyForAccountKey:accountKey keyId:keyId];
    if (self = [super initWithUniqueId:yapKey]) {
        self.accountKey = accountKey;
        self.keyId = keyId;
        self.keyData = keyData;
    }
    return self;
}

+ (NSString *)uniqueKeyForAccountKey:(NSString *)accountKey keyId:(uint32_t)keyId
{
    return [NSString stringWithFormat:@"%@-%d",accountKey,keyId];
}

@end
