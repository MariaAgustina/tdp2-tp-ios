//
//  AuthService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientProfile.h"

#define INEXISTENT_USER_STATUS_CODE 403
#define DUPLICATED_USER_STATUS_CODE 403

@protocol AuthServiceDelegate <NSObject>

@optional
- (void)didRegisterClient;
- (void)didFailRegistering: (BOOL)duplicatedUser;
- (void)didLoginClient;
- (void)didFailLogin: (BOOL)inexistentUser;

@end

@interface AuthService : NSObject

@property (nonatomic, weak) id<AuthServiceDelegate> delegate;

- (instancetype)initWithDelegate: (id<AuthServiceDelegate>)delegate;
- (void)registerClient: (ClientProfile*)profile;
- (void)loginClient:(NSString*)fbToken;
- (void)makeApiPostRequestWithRelativeUrlString: (NSString*)relativeUrlString
                                           body: (NSDictionary*)body
                                      authToken: (NSString*)authToken
                                        success: (void (^)(id _Nullable))success
                                        failure:(void (^)(NSError * _Nonnull, NSInteger statusCode))failure;
@end
