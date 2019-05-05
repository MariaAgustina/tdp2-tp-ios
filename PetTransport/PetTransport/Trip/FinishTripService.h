//
//  FinishTripService.h
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FinishTripServiceDelegate <NSObject>

- (void)finishTripServiceSuccededWithResponse:(NSDictionary*)response;
- (void)finishTripServiceFailedWithError:(NSError*)error;

@end


@interface FinishTripService : NSObject

- (instancetype)initWithDelegate:(id <FinishTripServiceDelegate>)delegate;
- (void)finishTrip:(Trip*)trip;

@end

NS_ASSUME_NONNULL_END
