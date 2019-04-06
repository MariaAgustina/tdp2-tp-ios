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
@property int locationFetchCounter;
@property (nonatomic, weak) id<LocationManagerDelegate> delegate;

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

// execute this method to start fetching location
- (void)fetchCurrentLocation: (id<LocationManagerDelegate>)delegate {
    self.delegate = delegate;
    self.locationFetchCounter = 0;
    
    // fetching current location start from here
    [self.cllocationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // this delegate method is constantly invoked every some miliseconds.
    // we only need to receive the first response, so we skip the others.
    if (self.locationFetchCounter > 0) {
        return;
    }
    self.locationFetchCounter++;
    CLLocation *currentLocation = [locations lastObject];
    struct LocationCoordinate coordinate;
    coordinate.latitude = currentLocation.coordinate.latitude;
    coordinate.longitude = currentLocation.coordinate.longitude;
    [self.delegate didFetchCurrentLocation:coordinate];    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to fetch current location : %@", error);
    [self.delegate didFailFetchingCurrentLocation];
}

// Lo dejo aca por si lo necesitamos despues
//- (void) getLocationInfo: (CLLocation *)location {
//    // after we have current coordinates, we use this method to fetch the information data of fetched coordinate
//    [self.clgeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark = [placemarks lastObject];
//        
//        NSString *street = placemark.thoroughfare;
//        NSString *city = placemark.locality;
//        NSString *posCode = placemark.postalCode;
//        NSString *country = placemark.country;
//        
//        NSLog(@"we live in %@, %@, %@, %@", country, city, street, posCode);
//        
//        // stopping locationManager from fetching again
//        [self.cllocationManager stopUpdatingLocation];
//    }];
//}

@end
