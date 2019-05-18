//
//  RoutesService.h
//  PetTransport
//
//  Created by agustina markosich on 5/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import "WayPoints.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RoutesServiceDelegate <NSObject>

@optional
- (void)succededReceivingRoute:(WayPoints*)wayPoints;
- (void)failedReceivingRoute;

@end

@interface RoutesService : NSObject

- (instancetype)initWithDelegate:(id <RoutesServiceDelegate>)delegate;
- (void)getTripCoordinates:(Trip*)trip;

@end

NS_ASSUME_NONNULL_END
