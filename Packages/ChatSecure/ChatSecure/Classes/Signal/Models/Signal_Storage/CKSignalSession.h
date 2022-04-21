//
//  CKSignalSession.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/26/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKSignalObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CKSignalSession : CKSignalObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic) int32_t deviceId;
@property (nonatomic, strong) NSData *sessionData;

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey name:(NSString *)name deviceId:(int32_t)deviceId sessionData:(NSData *)sessionData;

+ (NSString *)uniqueKeyForAccountKey:(NSString *)accountKey name:(NSString *)name deviceId:(int32_t)deviceId;

@end

NS_ASSUME_NONNULL_END
