//
//  DriverService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/27/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverService.h"
#import "LocationManager.h"

@interface DriverService () <LocationManagerDelegate>

@property (strong, nonatomic) NSString *token;
@property BOOL isWorking;
@property (strong, nonatomic) NSTimer *statusTimer;
@property (strong,nonatomic) LocationManager *locationManager;
@property struct LocationCoordinate currentLocation;

@end

@implementation DriverService

+ (instancetype)sharedInstance {
    static DriverService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DriverService alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    [self startUpdatingLocation];
    return self;
}

- (void)setDriverWithToken: (NSString*)token {
    self.token = token;
    [self startUpdatingStatus];
}

- (void)setWorking {
    self.isWorking = YES;
}

- (void)setNotWorking {
    self.isWorking = NO;
}


- (void)startUpdatingStatus {
    [self stopUpdatingStatus];
    [self updateStatus];
    self.statusTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(updateStatus)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateStatus {
    if (self.isWorking){
        NSLog(@"Trabajando");
    } else {
        NSLog(@"descansando");
    }
    NSLog(@"current location: %f, %f",self.currentLocation.latitude, self.currentLocation.longitude);
}

- (void)stopUpdatingStatus {
    [self.statusTimer invalidate];
    self.statusTimer = nil;
}

#pragma mark - Location
- (void)startUpdatingLocation {
    self.locationManager = [LocationManager new];
    [self.locationManager startUpdatingLocationWithDelegate:self];
}

- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    self.currentLocation = coordinate;
}

- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}


@end
