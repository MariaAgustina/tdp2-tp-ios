//
//  TripServiceDelegate.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import "WayPoints.h"
#import "ClientProfile.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TripServiceDelegate <NSObject>

@optional
- (void)didReturnTrip: (Trip*)trip;
- (void)succededReceivingRoute:(WayPoints*)wayPoints;
- (void)didReturnClient: (ClientProfile*)clientProfile;

@required
- (void)tripServiceFailedWithError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
