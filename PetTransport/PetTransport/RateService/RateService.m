//
//  RateService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateService.h"
#import "ApiClient.h"

@implementation RateService

- (void)rateClient: (RateModel*)rate forTrip:(Trip*)trip {
    NSString* relativeUrlString =[NSString stringWithFormat:@"trips/%ld/rate/client",trip.tripId] ;
    
    NSDictionary *body = @{
                           @"rating": [NSNumber numberWithInteger:rate.rating],
                           @"comments": rate.comments
                           };
    
//    ApiClient *apiClient = [ApiClient new];
//    [apiClient postWithRelativeUrlString:relativeUrlString
//                                    body:body
//                                   token: [[ClientService sharedInstance] getToken]
//                                 success:^(id _Nullable responseObject) {
//                                     __strong id <RateDriverServiceDelegate> strongDelegate = self.delegate;
//                                     [strongDelegate rateDriverServiceSuccededWithResponse:responseObject];
//                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
//                                     NSLog(@"Error: %@", error);
//                                     __strong id <RateDriverServiceDelegate> strongDelegate = self.delegate;
//                                     [strongDelegate rateDriverServiceFailedWithError:error];
//                                 }];
}

@end
