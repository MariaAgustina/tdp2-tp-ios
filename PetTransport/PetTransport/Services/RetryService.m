//
//  RetryService.m
//  PetTransport
//
//  Created by agustina markosich on 5/1/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RetryService.h"
#import "ApiClient.h"

@implementation RetryService

- (void)getTripOffer:(DriverProfile*)driverProfile{
    NSString *relativeUrlString = @"drivers/status";
    
    NSDictionary* locationDictionary = @{@"lat": [NSNumber numberWithDouble: driverProfile.currentLocation.latitude],@"lng": [NSNumber numberWithDouble: driverProfile.currentLocation.longitude]};
    
    NSDictionary *body = @{
                           @"currentLocation": locationDictionary,
                           @"status": driverProfile.status
                           };
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: driverProfile.fbToken
                                 success:^(id _Nullable responseObject) {
                                     //TODO
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     //TODO
                                 }];
}

@end
