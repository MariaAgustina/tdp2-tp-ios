//
//  CoordinateAddapter.h
//  PetTransport
//
//  Created by agustina markosich on 5/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "LocationCoordinate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoordinateAddapter : NSObject

+ (CLLocationCoordinate2D)getCoordinate:(struct LocationCoordinate)coordinate;

@end

NS_ASSUME_NONNULL_END
