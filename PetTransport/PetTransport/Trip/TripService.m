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
#import "IdentityService.h"
#import "ClientProfile.h"

@interface TripService ()

@property (nonatomic, weak) id <TripServiceDelegate> delegate;

@end

@implementation TripService

- (instancetype)initWithDelegate:(id <TripServiceDelegate>)delegate{
    self.delegate = delegate;
    return self;
}

-(NSDictionary*)tripRequestBody:(TripRequest*)tripRequest{
    NSDictionary* originDictionary = @{
                                       @"lat": [NSNumber numberWithDouble: tripRequest.origin.coordinate.latitude],
                                       @"lng": [NSNumber numberWithDouble: tripRequest.origin.coordinate.longitude],
                                       @"address": tripRequest.origin.name
                                       };
    NSDictionary* destinantionDictionary = @{
                                             @"lat": [NSNumber numberWithDouble: tripRequest.destiny.coordinate.latitude],
                                             @"lng": [NSNumber numberWithDouble: tripRequest.destiny.coordinate.longitude],
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
    return body;
}

- (void)sendTripRequest: (TripRequest*)tripRequest {
    //NSString* relativeUrlString = @"trips/simulated";
    NSString* relativeUrlString = @"trips";
    
    NSDictionary* body = [self tripRequestBody:tripRequest];
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: [[IdentityService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     
                                     Trip *trip = [[Trip alloc] initWithDictionary:responseObject];
                                     [strongDelegate didReturnTrip:trip];
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
        Trip *trip = [[Trip alloc] initWithDictionary:responseObject];
        __strong id <TripServiceDelegate> strongDelegate = self.delegate;
        [strongDelegate didReturnTrip:trip];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSString*)dateToString: (NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
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
                                   token: [[IdentityService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     WayPoints* wayPoints = [[WayPoints alloc]initWithDictionary:responseObject];
                                     [strongDelegate succededReceivingRoute:wayPoints];
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     NSLog(@"Error: %@", error);
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate tripServiceFailedWithError:error];
                                 }];
}

- (void)markTripAtOrigin:(Trip*)trip {
    [self updateTrip:trip withStatusKey:@"atorigin"];
}

- (void)markTripTravelling:(Trip*)trip {
    [self updateTrip:trip withStatusKey:@"travelling"];
}

- (void)markTripAtDestination:(Trip*)trip {
    [self updateTrip:trip withStatusKey:@"atdestination"];
}

- (void)markTripFinished:(Trip*)trip {
    [self updateTrip:trip withStatusKey:@"finished"];
}

- (void)markTripCancelled:(Trip*)trip {
    [self updateTrip:trip withStatusKey:@"cancelled"];
}

- (void)updateTrip:(Trip*)trip withStatusKey:(NSString*)statusKey {
    NSString* relativeUrlString = [NSString stringWithFormat:@"trips/%ld/status/%@",trip.tripId, statusKey];
    ApiClient *apiClient = [ApiClient new];
    [apiClient putWithRelativeUrlString:relativeUrlString
                                   body:@{}
                                  token:[[IdentityService sharedInstance] getToken]
                                success:^(id _Nullable responseObject) {
                                    __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                    Trip *trip = [[Trip alloc] initWithDictionary:responseObject];
                                    [strongDelegate didReturnTrip:trip];
                                } failure:^(NSError * _Nonnull error) {
                                    NSLog(@"Error: %@", error);
                                    __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                    [strongDelegate tripServiceFailedWithError:error];
                                }];
}

- (void)retrieveTripClient: (Trip*)trip {
    NSString* relativeUrlString = [NSString stringWithFormat:@"users/%ld",trip.clientId];
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient getWithRelativeUrlString:relativeUrlString token:nil success:^(id _Nullable responseObject){
        ClientProfile *profile = [ClientProfile new];
        profile.firstName = [responseObject objectForKey:@"name"];
        profile.phoneNumber = [responseObject objectForKey:@"phone"];
        __strong id <TripServiceDelegate> strongDelegate = self.delegate;
        [strongDelegate didReturnClient:profile];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)getTripPrice:(TripRequest*)tripRequest{
    NSString* relativeUrlString = @"info/costs";
    
    NSDictionary* body = [self tripRequestBody:tripRequest];
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient postWithRelativeUrlString:relativeUrlString
                                    body:body
                                   token: [[IdentityService sharedInstance] getToken]
                                 success:^(id _Nullable responseObject) {
                                     
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     
                                     CGFloat cost = [[responseObject objectForKey:@"cost"] floatValue];
                                     NSString* priceString = [NSString stringWithFormat: @"$ %.2f", cost];
                                     
                                     [strongDelegate succededReceivingPrice:priceString];
                                     
                                     
                                 } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                     NSLog(@"Error: %@", error);
                                     __strong id <TripServiceDelegate> strongDelegate = self.delegate;
                                     [strongDelegate tripServiceFailedWithError:error];
                                 }];
}

@end
