//
//  RateService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateService.h"
#import "ApiClient.h"
#import "IdentityService.h"

@interface RateService()

@property (strong, nonatomic) id<RateServiceDelegate> delegate;

@end

@implementation RateService

- (instancetype)initWithDelegate:(id <RateServiceDelegate>)delegate {
    self = [super init];
    self.delegate = delegate;
    return self;
}

- (void)rateClient: (RateModel*)rate forTripId:(NSInteger)tripId {
    NSString* relativeUrlString =[NSString stringWithFormat:@"trips/%ld/rate/client", tripId];
    
    NSDictionary *body = @{
                           @"rating": [NSNumber numberWithInteger:rate.rating],
                           @"comments": rate.comments
                           };
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: [[IdentityService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     __strong id <RateServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate rateSuccesful];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     NSLog(@"Error: %@", error);
                                     __strong id <RateServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate rateFailedWithError:error];
                                 }];
}

@end
