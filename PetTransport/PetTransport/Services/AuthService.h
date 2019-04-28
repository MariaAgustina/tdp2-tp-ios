//
//  AuthService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientProfile.h"
#import "DriverProfile.h"

#define INEXISTENT_USER_STATUS_CODE 403
#define DUPLICATED_USER_STATUS_CODE 403

@protocol AuthServiceDelegate <NSObject>

@optional

- (void)didRegister;
- (void)didFailRegistering: (BOOL)duplicatedUser;

- (void)didLoginWithToken: (NSString*)token;
- (void)didFailLogin: (BOOL)inexistentUser;

@end

@interface AuthService : NSObject

@property (nonatomic, weak) id<AuthServiceDelegate> delegate;

- (instancetype)initWithDelegate: (id<AuthServiceDelegate>)delegate;

- (void)loginClient:(NSString*)fbToken;
- (void)registerClient: (ClientProfile*)profile;

- (void)registerDriver:(DriverProfile*)profile;
- (void)loginDriver:(NSString*)fbToken;


@end
