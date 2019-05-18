//
//  RoutesService.m
//  PetTransport
//
//  Created by agustina markosich on 5/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RoutesService.h"
#import "ApiClient.h"
#import "ClientService.h"

@interface RoutesService ()

@property (nonatomic, weak) id <RoutesServiceDelegate> delegate;

@end

@implementation RoutesService


- (instancetype)initWithDelegate:(id <RoutesServiceDelegate>)delegate{
    self.delegate = delegate;
    return self;
}

- (void)getTripCoordinates:(Trip*)trip{

    NSString* relativeUrlString = @"info/route";
    
    NSDictionary* originDictionary = @{
                                       @"lat":[NSNumber numberWithDouble:trip.origin.coordinate.latitude],
                                        @"lng":[NSNumber numberWithDouble:trip.origin.coordinate.longitude],
                                        @"address": trip.origin.address
                                        };
    
    NSDictionary* destinationDictionary = @{
                                            @"lat":[NSNumber numberWithDouble:trip.destination.coordinate.latitude],
                                            @"lng":[NSNumber numberWithDouble:trip.destination.coordinate.longitude],
                                            @"address": trip.destination.address
                                            };
    
    
    NSDictionary* body = @{
                            @"origin": originDictionary,
                            @"destination": destinationDictionary
                            };
    
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: [[ClientService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     __strong id <RoutesServiceDelegate> strongDelegate = self.delegate;
                                     //TODO: create route
                                     WayPoints* wayPoints = [[WayPoints alloc]initWithDictionary:responseObject];
                                     [strongDelegate succededReceivingRoute:wayPoints];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     NSLog(@"Error: %@", error);
                                     __strong id <RoutesServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate failedReceivingRoute];
                                 }];
}


@end
