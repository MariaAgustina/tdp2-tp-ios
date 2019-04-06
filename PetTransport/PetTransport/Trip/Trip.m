//
//  Trip.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (BOOL)isValid
{
    return (self.origin && self.destiny);
}

- (struct LocationCoordinate)getOriginCoordinate {
    struct LocationCoordinate coordinate;
    coordinate.latitude = self.origin.coordinate.latitude;
    coordinate.longitude = self.origin.coordinate.longitude;
    return coordinate;
}

@end
