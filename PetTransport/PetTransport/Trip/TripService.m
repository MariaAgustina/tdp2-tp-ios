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

-(void)postTrip:(Trip*)trip {
    //NSString* relativeUrlString = @"trips/simulated";
    NSString* relativeUrlString = @"trips";
    
    NSDictionary* originDictionary = @{
                                       @"lat": [NSNumber numberWithDouble: trip.origin.coordinate.latitude],
                                       @"lng": [NSNumber numberWithDouble: trip.origin.coordinate.longitude],
                                       @"address": trip.origin.name
                                       };
    NSDictionary* destinantionDictionary = @{
                                             @"lat": [NSNumber numberWithDouble: trip.origin.coordinate.latitude],
                                             @"lng": [NSNumber numberWithDouble: trip.origin.coordinate.longitude],
                                             @"address": trip.destiny.name
                                             };
    
    NSNumber* smallPetsQuantity = [NSNumber numberWithDouble: trip.smallPetsQuantity];
    NSNumber* mediumPetsQuantity = [NSNumber numberWithDouble: trip.mediumPetsQuantity];
    NSNumber* bigPetsQuantity = [NSNumber numberWithDouble: trip.bigPetsQuantity];

    NSDictionary* petQuantitiesDictionary = @{@"small":smallPetsQuantity,@"medium":mediumPetsQuantity,@"big":bigPetsQuantity};
    
    NSString* paymentMethod = trip.selectedPaymentMethod.paymentKey;
    NSNumber* hasEscort = [NSNumber numberWithBool:trip.shouldHaveEscolt];
    
    
    
    NSDictionary *inmutableBody =  @{
                              @"origin":originDictionary,
                              @"destination":destinantionDictionary,
                              @"petQuantities":petQuantitiesDictionary,
                              @"paymentMethod":paymentMethod,
                              @"comments":trip.comments,
                              @"bringsEscort":hasEscort,
                          };
    
    NSMutableDictionary *body = [inmutableBody mutableCopy];
    if (trip.scheduleDate){
        [body setObject:[self dateToString:trip.scheduleDate] forKey:@"reservationDate"];
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

- (NSString*)dateToString: (NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

@end
