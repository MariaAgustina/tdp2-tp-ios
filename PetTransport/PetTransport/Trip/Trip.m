//
//  Trip.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (instancetype)init{
    if (self = [super init]){
        self.shouldHaveEscolt = NO;
    }
    return self;
}

- (BOOL)hasValidAdresses
{
    return (self.origin && self.destiny);
}

- (BOOL)hasPets
{
    return ([self totalPets] > 0);
}

- (BOOL)isValid
{
    return ([self hasValidAdresses] && [self hasPets]);
}

- (double)totalPets {
    return self.smallPetsQuantity + self.mediumPetsQuantity + self.bigPetsQuantity;
}


- (struct LocationCoordinate)getOriginCoordinate {
    struct LocationCoordinate coordinate;
    coordinate.latitude = self.origin.coordinate.latitude;
    coordinate.longitude = self.origin.coordinate.longitude;
    return coordinate;
}

@end
