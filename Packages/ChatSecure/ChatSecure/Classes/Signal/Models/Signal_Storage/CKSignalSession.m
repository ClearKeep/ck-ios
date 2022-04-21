//
//  CKSignalSession.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalSession.h"

@implementation CKSignalSession

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey name:(NSString *)name deviceId:(int32_t)deviceId sessionData:(NSData *)sessionData
{
    NSString *yapKey = [[self class] uniqueKeyForAccountKey:accountKey name:name deviceId:deviceId];
    if (self = [super initWithUniqueId:yapKey] ) {
        self.accountKey = accountKey;
        self.name = name;
        self.deviceId = deviceId;
        self.sessionData = sessionData;
    }
    return self;
}

+ (NSString *)uniqueKeyForAccountKey:(NSString *)accountKey name:(NSString *)name deviceId:(int32_t)deviceId
{
    return [NSString stringWithFormat:@"%@-%@-%d",accountKey,name,deviceId];
}

@end
