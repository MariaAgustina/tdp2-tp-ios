//
//  CoordinateAddapter.m
//  PetTransport
//
//  Created by agustina markosich on 5/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "CoordinateAddapter.h"

@implementation CoordinateAddapter

+ (CLLocationCoordinate2D)getCoordinate:(struct LocationCoordinate)coordinate{
    return CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
}

@end
