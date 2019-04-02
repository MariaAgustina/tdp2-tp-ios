//
//  TrackDriverService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationCoordinate.h"

@protocol TrackDriverServideDelegate <NSObject>

- (void)didUpdateDriverLocation: (struct LocationCoordinate)coordinate;
- (void)didFailTracking;

@end

@interface TrackDriverService : NSObject

+ (instancetype)sharedInstance;
- (void)startTrackingDriverWithDelegate:(id<TrackDriverServideDelegate>)delegate;
    
@end
