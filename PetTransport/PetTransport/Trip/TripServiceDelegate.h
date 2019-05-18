//
//  TripServiceDelegate.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TripServiceDelegate <NSObject>

@optional
- (void)didReturnTrip: (Trip*)trip;
- (void)tripServiceSuccededWithResponse:(NSDictionary*)response;

@required
- (void)tripServiceFailedWithError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
