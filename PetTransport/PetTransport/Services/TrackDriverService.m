//
//  TrackDriverService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TrackDriverService.h"
#import <UIKit/UIKit.h>
#import "constants.h"
#import "ApiClient.h"

@interface TrackDriverService ()

@property (nonatomic, weak) id<TrackDriverServideDelegate> delegate;
@property (strong, nonatomic) NSTimer *timer;
@property NSInteger tripId;

@end

@implementation TrackDriverService

+ (instancetype)sharedInstance {
    static TrackDriverService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrackDriverService alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    return self;
}

- (void)startTrackingDriverForTrip:(NSInteger)tripId WithDelegate:(id<TrackDriverServideDelegate>)delegate {
    self.delegate = delegate;
    self.tripId = tripId;
    [self startUpdating];
}

- (void)startUpdating {
    [self updateDriverLocation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(updateDriverLocation)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateDriverLocation {
    if (self.delegate == nil){
        [self stopTracking];
        return;
    }
    
    NSString* relativeUrlString = [NSString stringWithFormat:@"trips/%ld/location",self.tripId];
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient getWithRelativeUrlString:relativeUrlString token:nil success:^(id _Nullable responseObject){
        [self didUpdateDriverLocationWithResponse: responseObject];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [self didFailUpdating];
    }];
}

- (void) didUpdateDriverLocationWithResponse:(NSDictionary *)responseObject{
    DriverStatus status = [self statusFromResponse:responseObject];
    if (status == DRIVER_STATUS_CANCELLED || status == DRIVER_STATUS_SEARCHING){
        struct LocationCoordinate emptyLocation;
        [self didUpdateDriverLocation:emptyLocation withStatus:status];
        return;
    }
    struct LocationCoordinate location = [self coordinateFromResponse:responseObject];
    [self didUpdateDriverLocation:location withStatus:status];
}

- (struct LocationCoordinate)coordinateFromResponse:(NSDictionary *)responseObject {
    NSDictionary *currentLocation = [responseObject objectForKey:@"currentLocation"];
    struct LocationCoordinate coordinate;
    coordinate.latitude = [[currentLocation objectForKey:@"lat"] doubleValue];
    coordinate.longitude = [[currentLocation objectForKey:@"lng"] doubleValue];
    return coordinate;
}

- (DriverStatus)statusFromResponse:(NSDictionary *)responseObject {
    NSString *statusString = [responseObject objectForKey:@"status"];
    if ([statusString isEqualToString:@"En camino"]){
        return DRIVER_STATUS_GOING;
    }
    if ([statusString isEqualToString:@"En origen"]){
        return DRIVER_STATUS_IN_ORIGIN;
    }
    if ([statusString isEqualToString:@"Cancelado"]){
        return DRIVER_STATUS_CANCELLED;
    }
    if ([statusString isEqualToString:@"Buscando"]){
        return DRIVER_STATUS_SEARCHING;
    }
    return DRIVER_STATUS_SEARCHING;
}

- (void)didUpdateDriverLocation:(struct LocationCoordinate)location withStatus:(DriverStatus)status {
    BOOL didArrive = (status == DRIVER_STATUS_IN_ORIGIN);
    [self.delegate didUpdateDriverLocation:location andStatus:status];
    if (didArrive) {
        [self stopTracking];
    }
}

- (void)stopTracking {
    [self.timer invalidate];
    self.timer = nil;
    self.delegate = nil;
    self.tripId = 0;
}

- (void)didFailUpdating {
    [self.delegate didFailTracking];
}

@end
