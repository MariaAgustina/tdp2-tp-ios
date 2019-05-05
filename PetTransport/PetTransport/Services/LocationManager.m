//
//  LocationManager.m
//  PetTransport
//
//  Created by Kaoru Heanna on 3/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager ()<CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *cllocationManager;
@property(nonatomic,retain) CLGeocoder *clgeocoder;
@property (nonatomic, weak) id<LocationManagerDelegate> delegate;
@property struct LocationCoordinate lastLocation;

@end

@implementation LocationManager

- (id)init {
    self = [super init];
    
    self.cllocationManager = [[CLLocationManager alloc] init];
    self.cllocationManager.delegate = self;
    self.cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.clgeocoder = [[CLGeocoder alloc] init];
    
    return self;
}

- (void)startUpdatingLocationWithDelegate: (id<LocationManagerDelegate>)delegate {
    [self.cllocationManager requestWhenInUseAuthorization];
    self.delegate = delegate;
    [self.cllocationManager startUpdatingLocation];
}

- (void)fetchCurrentLocation: (id<LocationManagerDelegate>)delegate {
    self.delegate = delegate;
    [self.cllocationManager requestLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    struct LocationCoordinate coordinate;
    coordinate.latitude = currentLocation.coordinate.latitude;
    coordinate.longitude = currentLocation.coordinate.longitude;
    
    if ((self.lastLocation.latitude == coordinate.latitude) && (self.lastLocation.longitude == coordinate.longitude)){
        return;
    }
    self.lastLocation = coordinate;
    [self.delegate didFetchCurrentLocation:coordinate];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to fetch current location : %@", error);
    [self.delegate didFailFetchingCurrentLocation];
}

@end
