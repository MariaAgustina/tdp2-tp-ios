//
//  RateDriverService.m
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateDriverService.h"
#import "RateModel.h"
#import "ApiClient.h"
#import "ClientService.h"

@interface RateDriverService ()

@property (nonatomic, weak) id <RateDriverServiceDelegate> delegate;

@end

@implementation RateDriverService

- (instancetype)initWithDelegate:(id <RateDriverServiceDelegate>)delegate{
    self.delegate = delegate;
    return self;
}

- (void)postRate:(RateModel*)rate trip:(Trip*)trip{

    NSString* relativeUrlString =[NSString stringWithFormat:@"trips/%ld/rate/driver",(long)trip.tripId] ;
    
    NSDictionary* suggestionsDictionary = @{
                                       @"app": [NSNumber numberWithBool:rate.app],
                                       @"vehicle": [NSNumber numberWithBool:rate.vehicle],
                                       @"driver": [NSNumber numberWithBool:rate.driver]
                                       };
    
    NSDictionary *body =  @{
                            @"rating": [NSNumber numberWithInteger:rate.rating],
                            @"suggestions":suggestionsDictionary
                            };
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: [[ClientService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     __strong id <RateDriverServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate rateDriverServiceSuccededWithResponse:responseObject];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     NSLog(@"Error: %@", error);
                                     __strong id <RateDriverServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate rateDriverServiceFailedWithError:error];
                                 }];
}



@end
