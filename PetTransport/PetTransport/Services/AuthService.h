//
//  AuthService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientProfile.h"

@protocol AuthServiceDelegate <NSObject>

- (void)didRegisterClient;
- (void)didFailRegistering;

@end

@interface AuthService : NSObject

- (instancetype)initWithDelegate: (id<AuthServiceDelegate>)delegate;
- (void)registerClient: (ClientProfile*)profile;

@end
