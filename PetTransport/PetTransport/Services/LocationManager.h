//
//  LocationManager.h
//  PetTransport
//
//  Created by Kaoru Heanna on 3/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

struct LocationCoordinate {
    double latitude;
    double longitude;
};

@protocol LocationManagerDelegate <NSObject>

- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate;
- (void)didFailFetchingCurrentLocation;

@end

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;
- (void)fetchCurrentLocation: (id<LocationManagerDelegate>)delegate;

@end
