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

@interface DriverService () <LocationManagerDelegate>

@property (strong, nonatomic) NSString *token;
@property BOOL isWorking;
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

- (void)updateTrip:(Trip *)trip {
    NSString* relativeUrlString = [NSString stringWithFormat:@"trips/%ld", trip.tripId];
    
    NSDictionary *body = [trip toDictionary];
    NSLog(@"body: %@", body);
    
    ApiClient *apiClient = [ApiClient new];
    [apiClient putWithRelativeUrlString:relativeUrlString
                                   body: body
                                  token: self.token
                                success:^(id _Nullable responseObject){
                                    NSLog(@"1) response: %@", responseObject);
                                } failure:^(NSError * _Nonnull error) {
                                    NSLog(@"Error: %@", error);
                                }];
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
    
    [apiClient putWithRelativeUrlString:relativeUrlString body:body token:self.token success:^(id _Nullable responseObject){
        NSLog(@"Response object: %@", responseObject);
        if ([responseObject objectForKey:@"tripOffer"] != nil){
            Trip *trip = [[Trip alloc] initWithDictionary:[responseObject objectForKey:@"tripOffer"]];
            [self.delegate didReceiveTripOffer:trip];
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Fallo al actualizar el status del conductor");
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
