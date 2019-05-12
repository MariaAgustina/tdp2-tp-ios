//
//  PTLocation.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/12/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "PTLocation.h"

@implementation PTLocation

- (instancetype)initWithDictionary: (NSDictionary*)dictionary {
    self = [super init];
    
    self.address = [dictionary objectForKey:@"address"];
    NSString *latitudeString = [dictionary objectForKey:@"lat"];
    NSString *longitudeString = [dictionary objectForKey:@"lng"];
    
    struct LocationCoordinate coordinate;
    coordinate.latitude = [latitudeString doubleValue];
    coordinate.longitude = [longitudeString doubleValue];
    self.coordinate = coordinate;
    
    return self;
}

@end
