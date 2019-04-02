//
//  TripService.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TripService.h"
#import "AFNetworking.h"

@interface TripService ()
@property (nonatomic, weak) id <TripServiceDelegate> delegate;
@end

@implementation TripService

- (instancetype)initWithDelegate:(id <TripServiceDelegate>)delegate{
    self.delegate = delegate;
    return self;
}

-(void)postTrip:(Trip*)trip
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString* urlString = [NSString stringWithFormat:@"http://localhost:3000/trips"];
    
    //TODO Agus: esto es solo para probar el post cuando este el cambio de firma
    NSDictionary* originDictionary = @{@"lat": [NSNumber numberWithDouble: trip.origin.coordinate.latitude]  ,@"lng": [NSNumber numberWithDouble: trip.origin.coordinate.longitude]};
    NSDictionary* destinantionDictionary = @{@"lat": [NSNumber numberWithDouble: trip.origin.coordinate.latitude]  ,@"lng": [NSNumber numberWithDouble: trip.origin.coordinate.longitude]};
    
    NSDictionary *parameters = @{@"origin": @"11111" ,@"destination": @"22222"};
   
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        __strong id <TripServiceDelegate> strongDelegate = self.delegate;
        [strongDelegate tripServiceSuccededWithResponse:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        __strong id <TripServiceDelegate> strongDelegate = self.delegate;
        [strongDelegate tripServiceFailedWithError:error];
    }];
}

@end
