//
//  AuthService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "AuthService.h"
#import "ApiClient.h"
#import "UIImage+Base64.h"

@interface AuthService ()

@end

@implementation AuthService

- (instancetype)initWithDelegate: (id<AuthServiceDelegate>)delegate {
    self = [super init];
    self.delegate = delegate;
    return self;
}

- (void)loginClient:(NSString*)fbToken {
    NSString *relativeUrlString = @"auth/client/facebook/login";
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:nil
                                   token: fbToken
                                 success:^(id _Nullable responseObject) {
                                     ClientProfile* client = [ClientProfile new];
                                     client.fbToken = fbToken;
                                     [self.delegate didLoginWithProfile:client];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     BOOL inexistentUser = (statusCode == INEXISTENT_USER_STATUS_CODE);
                                     BOOL disabledUser = (statusCode == DISABLED_USER_STATUS_CODE);
                                     [self.delegate didFailLogin:inexistentUser disabledUser:disabledUser];
                                 }];
}

- (void)registerClient: (ClientProfile*)profile {
    NSString *relativeUrlString = @"auth/client/facebook/register";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *birthdate = [formatter stringFromDate:profile.birthdate];
    
    NSDictionary *body = @{
                           @"email": profile.email,
                           @"birthDate": birthdate,
                           @"address": profile.address,
                           @"phone": profile.phoneNumber
                        };
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: profile.fbToken
                                 success:^(id _Nullable responseObject) {
                                     [self.delegate didRegister];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     BOOL duplicatedUser = (statusCode == DUPLICATED_USER_STATUS_CODE);
                                     [self.delegate didFailRegistering:duplicatedUser];
                                 }];
}

- (void)loginDriver:(NSString*)fbToken {
    NSString *relativeUrlString = @"auth/driver/facebook/login";
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:nil
                                   token: fbToken
                                 success:^(id _Nullable responseObject) {
                                     //TODO driver params
                                     DriverProfile* driver = [DriverProfile new];
                                     driver.fbToken = fbToken;
                                     [self.delegate didLoginWithProfile:driver];
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
                                 @"transportImage": [profile.transportImage getBase64],
                                 };
    
    NSDictionary *body = @{
                           @"email": profile.email,
                           @"birthDate": birthdate,
                           @"address": profile.address,
                           @"phone": profile.phoneNumber,
                           @"driverData":driverData
                           };
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: profile.fbToken
                                 success:^(id _Nullable responseObject) {
                                     [self.delegate didRegister];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     BOOL duplicatedUser = (statusCode == DUPLICATED_USER_STATUS_CODE);
                                     [self.delegate didFailRegistering:duplicatedUser];
                                 }];
}

@end
