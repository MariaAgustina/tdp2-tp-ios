//
//  TripService.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TripService.h"
#import "AFNetworking.h"
#import "constants.h"

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
    
    NSString* relativeUrl = @"trips/simulated";
    NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_BASE_URL, relativeUrl];
    NSLog(@"urlString: %@",urlString);
    
    NSDictionary* originDictionary = @{@"lat": [NSNumber numberWithDouble: trip.origin.coordinate.latitude]  ,@"lng": [NSNumber numberWithDouble: trip.origin.coordinate.longitude]};
    NSDictionary* destinantionDictionary = @{@"lat": [NSNumber numberWithDouble: trip.origin.coordinate.latitude]  ,@"lng": [NSNumber numberWithDouble: trip.origin.coordinate.longitude]};
    
    
    NSNumber* smallPetsQuantity = [NSNumber numberWithDouble: trip.smallPetsQuantity];
    NSNumber* mediumPetsQuantity = [NSNumber numberWithDouble: trip.mediumPetsQuantity];
    NSNumber* bigPetsQuantity = [NSNumber numberWithDouble: trip.bigPetsQuantity];

    NSDictionary* petQuantitiesDictionary = @{@"small":smallPetsQuantity,@"medium":mediumPetsQuantity,@"big":bigPetsQuantity};
    
    NSString* paymentMethod = trip.selectedPaymentMethod.paymentKey;
    NSNumber* hasEscort = [NSNumber numberWithBool:trip.shouldHaveEscolt];
    
    NSDictionary *parameters = @{@"origin":originDictionary,@"destination":destinantionDictionary,@"petQuantities":petQuantitiesDictionary,@"paymentMethod":paymentMethod,@"comments":trip.comments,@"bringsEscort":hasEscort};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager POST:urlString parameters: parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        __strong id <TripServiceDelegate> strongDelegate = self.delegate;
        [strongDelegate tripServiceSuccededWithResponse:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        __strong id <TripServiceDelegate> strongDelegate = self.delegate;
        [strongDelegate tripServiceFailedWithError:error];
    }];
}

@end
