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

NS_ASSUME_NONNULL_BEGIN

@interface TripService : NSObject

- (instancetype)initWithDelegate:(id <TripServiceDelegate>)delegate;
- (void)postTrip:(Trip*)trip;

@end

NS_ASSUME_NONNULL_END
