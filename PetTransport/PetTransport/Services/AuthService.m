//
//  AuthService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "AuthService.h"
#import "AFNetworking.h"
#import "constants.h"

@interface AuthService ()

@property (nonatomic, weak) id<AuthServiceDelegate> delegate;

@end

@implementation AuthService

- (instancetype)initWithDelegate: (id<AuthServiceDelegate>)delegate {
    self = [super init];
    self.delegate = delegate;
    return self;
}

- (void)registerClient: (ClientProfile*)profile {
    NSString *relativeUrlString = @"auth/facebook/register";
    
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
    
    [self makeApiPostRequestWithRelativeUrlString:relativeUrlString
                                             body:body
                                        authToken: profile.fbToken
                                          success:^(id _Nullable responseObject) {
                                              NSLog(@"Un exito! %@", responseObject);
                                              [self.delegate didRegisterClient];
                                          } failure:^(NSError * _Nonnull error) {
                                              NSLog(@"fallo!: %@", error);
                                              [self.delegate didFailRegistering];
                                          }];
}


- (void)makeApiPostRequestWithRelativeUrlString: (NSString*)relativeUrlString
                                           body: (NSDictionary*)body
                                        authToken: (NSString*)authToken
                                        success: (void (^)(id _Nullable))success
                                        failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_BASE_URL, relativeUrlString];
    
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@",authToken];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager POST:urlString parameters: body progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}

@end
