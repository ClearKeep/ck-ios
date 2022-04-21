//
//  CKSignalSenderKey.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CKSignalSenderKey : CKSignalObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int32_t deviceId;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSData *senderKey;

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey
                                       name:(NSString *)name
                                   deviceId:(int32_t)deviceId
                                    groupId:(NSString *)groupId
                                  senderKey:(NSData *)senderKey;

+ (NSString *)uniqueKeyFromAccountKey:(NSString *)accountKey
                                 name:(NSString *)name
                             deviceId:(int32_t)deviceId
                              groupId:(NSString *)groupId;

@end

NS_ASSUME_NONNULL_END
