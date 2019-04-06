//
//  Trip.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationCoordinate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Trip : NSObject

@property (strong, nonatomic) GMSPlace *origin;
@property (strong, nonatomic) GMSPlace *destiny;

@property (assign, nonatomic) NSInteger tripId;

- (BOOL)isValid;
- (struct LocationCoordinate)getOriginCoordinate;

@end

NS_ASSUME_NONNULL_END
