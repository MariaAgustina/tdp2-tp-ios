//
//  TripService.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripServiceDelegate.h"
#import "Trip.h"
#import "TripRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface TripService : NSObject

- (instancetype)initWithDelegate:(id <TripServiceDelegate>)delegate;
- (void)sendTripRequest: (TripRequest*)tripRequest;
- (void)retrieveTripWithId: (NSInteger)tripId;
- (void)getTripCoordinates:(Trip*)trip;
- (void)markTripAtOrigin:(Trip*)trip;
- (void)markTripTravelling:(Trip*)trip;
- (void)markTripAtDestination:(Trip*)trip;
- (void)markTripFinished:(Trip*)trip;
- (void)markTripCancelled:(Trip*)trip;
- (void)retrieveTripClient: (Trip*)trip;

@end

NS_ASSUME_NONNULL_END
