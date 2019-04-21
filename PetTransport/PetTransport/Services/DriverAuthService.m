//
//  DriverAuthService.m
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverAuthService.h"
#import "DriverProfile.h"
#import "UIImage+Base64.h"

@implementation DriverAuthService

- (void)loginDriver:(NSString*)fbToken {
    NSString *relativeUrlString = @"auth/driver/facebook/login";
    [self makeApiPostRequestWithRelativeUrlString:relativeUrlString
                                             body:nil
                                        authToken: fbToken
                                          success:^(id _Nullable responseObject) {
                                              [self.delegate didLoginClient];
                                          } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                              BOOL inexistentUser = (statusCode == INEXISTENT_USER_STATUS_CODE);
                                              [self.delegate didFailLogin:inexistentUser];
                                          }];
}

- (void)registerDriver:(DriverProfile*)profile {
    NSString *relativeUrlString = @"auth/driver/facebook/register";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *birthdate = [formatter stringFromDate:profile.birthdate];
    
    NSDictionary* driverData = @{
                                 @"drivingRecordImage": [profile.drivingRecordImage getBase64],
                                 @"policyImage":[profile.policyImage getBase64],
                                 @"transportImage":[profile.transportImage getBase64]
                                 };
    
    NSDictionary *body = @{
                           @"email": profile.email,
                           @"birthDate": birthdate,
                           @"address": profile.address,
                           @"phone": profile.phoneNumber,
                           @"driverData":driverData
                           };
    
    [self makeApiPostRequestWithRelativeUrlString:relativeUrlString
                                             body:body
                                        authToken: profile.fbToken
                                          success:^(id _Nullable responseObject) {
                                              [self.delegate didRegisterClient];
                                          } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                              BOOL duplicatedUser = (statusCode == DUPLICATED_USER_STATUS_CODE);
                                              [self.delegate didFailRegistering:duplicatedUser];
                                          }];
}


@end
