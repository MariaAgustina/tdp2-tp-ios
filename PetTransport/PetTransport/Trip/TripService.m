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
#import "ApiClient.h"
#import "FbProfileManager.h"
#import "ClientService.h"

@interface TripService ()

@property (nonatomic, weak) id <TripServiceDelegate> delegate;

@end

@implementation TripService

- (instancetype)initWithDelegate:(id <TripServiceDelegate>)delegate{
    self.delegate = delegate;
    return self;
}

- (void)sendTripRequest: (TripRequest*)tripRequest {
    //NSString* relativeUrlString = @"trips/simulated";
    NSString* relativeUrlString = @"trips";
    
    NSDictionary* originDictionary = @{
                                       @"lat": [NSNumber numberWithDouble: tripRequest.origin.coordinate.latitude],
                                       @"lng": [NSNumber numberWithDouble: tripRequest.origin.coordinate.longitude],
                                       @"address": tripRequest.origin.name
                                       };
    NSDictionary* destinantionDictionary = @{
                                             @"lat": [NSNumber numberWithDouble: tripRequest.origin.coordinate.latitude],
                                             @"lng": [NSNumber numberWithDouble: tripRequest.origin.coordinate.longitude],
                                             @"address": tripRequest.destiny.name
                                             };
    
    NSNumber* smallPetsQuantity = [NSNumber numberWithDouble: tripRequest.smallPetsQuantity];
    NSNumber* mediumPetsQuantity = [NSNumber numberWithDouble: tripRequest.mediumPetsQuantity];
    NSNumber* bigPetsQuantity = [NSNumber numberWithDouble: tripRequest.bigPetsQuantity];

    NSDictionary* petQuantitiesDictionary = @{@"small":smallPetsQuantity,@"medium":mediumPetsQuantity,@"big":bigPetsQuantity};
    
    NSString* paymentMethod = tripRequest.selectedPaymentMethod.paymentKey;
    NSNumber* hasEscort = [NSNumber numberWithBool:tripRequest.shouldHaveEscort];
    
    NSDictionary *inmutableBody =  @{
                              @"origin":originDictionary,
                              @"destination":destinantionDictionary,
                              @"petQuantities":petQuantitiesDictionary,
                              @"paymentMethod":paymentMethod,
                              @"comments":tripRequest.comments,
                              @"bringsEscort":hasEscort,
                          };
    
    NSMutableDictionary *body = [inmutableBody mutableCopy];
    if (tripRequest.scheduleDate){
        [body setObject:[self dateToString:tripRequest.scheduleDate] forKey:@"reservationDate"];
    }
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: [[ClientService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate tripServiceSuccededWithResponse:responseObject];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     NSLog(@"Error: %@", error);
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate tripServiceFailedWithError:error];
                                 }];
}

- (void)retrieveTripWithId: (NSInteger)tripId {
    NSString* relativeUrlString = [NSString stringWithFormat:@"trips/%ld",tripId];
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient getWithRelativeUrlString:relativeUrlString token:nil success:^(id _Nullable responseObject){
        NSLog(@"response: %@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSString*)dateToString: (NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

@end
