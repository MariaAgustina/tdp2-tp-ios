//
//  TrackDriverService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationCoordinate.h"

typedef NS_ENUM(NSInteger, DriverStatus) {
    DRIVER_STATUS_GOING = 1,
    DRIVER_STATUS_IN_ORIGIN = 2
};

@protocol TrackDriverServideDelegate <NSObject>

- (void)didUpdateDriverLocation: (struct LocationCoordinate)coordinate andStatus:(DriverStatus)status;
- (void)didFailTracking;

@end

@interface TrackDriverService : NSObject

+ (instancetype)sharedInstance;
- (void)startTrackingDriverForTrip:(NSInteger)tripId WithDelegate:(id<TrackDriverServideDelegate>)delegate;
- (void)stopTracking;
    
@end
