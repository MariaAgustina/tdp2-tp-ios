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
@property (strong, nonatomic) NSTimer *timer;
@property (strong,nonatomic) LocationManager *locationManager;

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
    self.locationManager = [LocationManager new];
    return self;
}

- (void)setDriverWithToken: (NSString*)token {
    self.token = token;
    [self stopUpdatingStatus];
    [self updateStatus];
    [self startUpdatingStatus];
}

- (void)setWorking {
    self.isWorking = YES;
}

- (void)setNotWorking {
    self.isWorking = NO;
}


- (void)startUpdatingStatus {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(updateStatus)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateStatus {
    NSLog(@"actualizo mi status");
    if (self.isWorking){
        NSLog(@"Trabajando");
    } else {
        NSLog(@"descansando");
    }
}

- (void)stopUpdatingStatus {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - LocationManagerDelegate
- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    
}

- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}


@end
