//
//  CKSignalIdentity.m
//
//  Created by Luan Nguyen on 10/21/20.
//  Copyright © 2020 Luan Nguyen. All rights reserved.
//

#import "CKAccountSignalIdentity.h"

@implementation CKAccountSignalIdentity

- (nullable instancetype)initWithAccountKey:(NSString *)accountKey
                            identityKeyPair:(SignalIdentityKeyPair *)identityKeyPair
                             registrationId:(uint32_t)registrationId
{
    if (self = [super initWithUniqueId:accountKey]) {
        self.accountKey = accountKey;
        self.identityKeyPair = identityKeyPair;
        self.registrationId = registrationId;
    }
    return self;
}

@end
