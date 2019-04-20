//
//  DriverAuthService.h
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "AuthService.h"
#import "DriverProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface DriverAuthService : AuthService

- (void)loginDriver:(NSString*)fbToken;
- (void)registerDriver:(DriverProfile*)profile;

@end

NS_ASSUME_NONNULL_END
