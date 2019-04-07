//
//  TrackDriverService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TrackDriverService.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "constants.h"

@interface TrackDriverService ()

@property (nonatomic, weak) id<TrackDriverServideDelegate> delegate;
@property (strong, nonatomic) NSTimer *timer;
@property NSInteger tripId;
@property (strong, nonatomic) AFHTTPSessionManager *httpManager;

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

- (AFHTTPSessionManager *)httpManager {
    if (_httpManager == nil){
        _httpManager = [AFHTTPSessionManager manager];
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];

    }
    return _httpManager;
}

- (void)startTrackingDriverForTrip:(NSInteger)tripId WithDelegate:(id<TrackDriverServideDelegate>)delegate {
    self.delegate = delegate;
    self.tripId = tripId;
    [self startUpdating];
}

- (void)startUpdating {
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
    
    NSString* relativeUrl = [NSString stringWithFormat:@"trips/%ld/location",self.tripId];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_BASE_URL, relativeUrl];
    [self.httpManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        struct LocationCoordinate location = [self coordinateFromResponse:responseObject];
        DriverStatus status = [self statusFromResponse:responseObject];
        [self didUpdateDriverLocation:location withStatus:status];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self didFailUpdating];
    }];
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
    return DRIVER_STATUS_GOING;
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
