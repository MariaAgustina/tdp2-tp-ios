//
//  DriverService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/27/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverService.h"
#import "LocationManager.h"
#import "ApiClient.h"
#import "IdentityService.h"

@interface DriverService () <LocationManagerDelegate>

@property BOOL working;
@property (strong, nonatomic) NSTimer *statusTimer;
@property (strong,nonatomic) LocationManager *locationManager;
@property struct LocationCoordinate currentLocation;
@property (copy,nonatomic)NSString* driverStatus;

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
    self.working = NO;
    [self startUpdatingLocation];
    return self;
}

- (void)setDriverWithToken: (NSString*)token {
    IdentityService *identityService = [IdentityService sharedInstance];
    [identityService setAsDriver];
    [identityService setToken:token];
    [self startUpdatingStatus];
}

- (void)setWorking {
    self.working = YES;
}

- (void)setNotWorking {
    self.working = NO;
}

- (BOOL)isWorking {
    return self.working;
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
    if (self.working){
        self.driverStatus = @"Disponible";
    } else {
        self.driverStatus = @"No disponible";
    }

    if(!self.currentLocation.longitude || !self.currentLocation.latitude){
        return;
    }
    [self putStatusWithBody:[self bodyWithLocationAndStatus]];
}


- (void)stopUpdatingStatus {
    //TODO: cancel pending request
    [self.statusTimer invalidate];
    self.statusTimer = nil;
}

- (void)acceptTrip:(Trip *)trip {
    [trip accept];
    [self updateTrip:trip];
}

- (void)rejectTrip:(Trip *)trip {
    [trip reject];
    [self updateTrip:trip];
}

- (void)updateTrip: (Trip*)trip {
    NSMutableDictionary *body = [[self bodyWithLocationAndStatus] mutableCopy];
    [body setObject:[trip toDictionary] forKey:@"tripOffer"];
    [self putStatusWithBody:body];
}

- (NSDictionary*)bodyWithLocationAndStatus{
    NSDictionary* locationDictionary = @{@"lat": [NSNumber numberWithDouble: self.currentLocation.latitude],@"lng": [NSNumber numberWithDouble: self.currentLocation.longitude]};
    
    return @{
             @"currentLocation": locationDictionary,
             @"status": self.driverStatus
             };
}

- (void)putStatusWithBody:(NSDictionary*)body{
    NSString *relativeUrlString = @"drivers/status";
    
    ApiClient *apiClient = [ApiClient new];
    NSString *token = [[IdentityService sharedInstance] getToken];
    [apiClient putWithRelativeUrlString:relativeUrlString body:body token:token success:^(id _Nullable responseObject){
        if (!self.working){
            return;
        }
        if ([responseObject objectForKey:@"tripOffer"] != nil){
            //NSLog(@"Response object: %@", responseObject);
            Trip *trip = [[Trip alloc] initWithDictionary:[responseObject objectForKey:@"tripOffer"]];
            [self.delegate didReceiveTripOffer:trip];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Fallo al actualizar el status del conductor");
    }];
}

- (void)getSummaryWithDelegate: (id<SummaryDelegate>)summaryDelegate {
    NSString *relativeUrlString = @"drivers/summary";
    
    ApiClient *apiClient = [ApiClient new];
    NSString *token = [[IdentityService sharedInstance] getToken];
    [apiClient getWithRelativeUrlString:relativeUrlString token:token success:^(id _Nullable responseObject){
        __strong id <SummaryDelegate> strongDelegate = summaryDelegate;
        DriverSummary *summary = [[DriverSummary alloc] initWithDictionary:responseObject];
        [strongDelegate didReceiveSummary:summary];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Fallo el get summary");
    }];
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
