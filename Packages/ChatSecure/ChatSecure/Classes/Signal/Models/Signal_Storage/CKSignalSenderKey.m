//
//  CKSignalSenderKey.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalSenderKey.h"

@implementation CKSignalSenderKey

- (instancetype)initWithAccountKey:(NSString *)accountKey
                              name:(NSString *)name
                          deviceId:(int32_t)deviceId
                           groupId:(NSString *)groupId
                         senderKey:(NSData *)senderKey
{
    if (self = [super initWithUniqueId:[[self class] uniqueKeyFromAccountKey:accountKey
                                                                        name:name
                                                                    deviceId:deviceId
                                                                     groupId:groupId]]) {
        self.accountKey = accountKey;
        self.name = name;
        self.deviceId = deviceId;
        self.groupId = groupId;
        self.senderKey = senderKey;
    }
    return self;
}

+ (NSString *)uniqueKeyFromAccountKey:(NSString *)accountKey
                                 name:(NSString *)name
                             deviceId:(int32_t)deviceId
                              groupId:(NSString *)groupId {
    return [NSString stringWithFormat:@"%@-%@-%d-%@", accountKey, name, deviceId, groupId];
}

@end
