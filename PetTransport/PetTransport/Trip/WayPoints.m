//
//  WayPoints.m
//  PetTransport
//
//  Created by agustina markosich on 5/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "WayPoints.h"

@implementation WayPoints

- (instancetype)initWithDictionary: (NSDictionary*)dictionary{
    NSMutableArray<CLLocation*>* mutableWaypoitns = [NSMutableArray new];

    NSArray* wayPointsArray = [dictionary mutableArrayValueForKey:@"waypoints"];
    for(NSDictionary* point in wayPointsArray){
        double lat = [[point objectForKey:@"lat"] doubleValue];
        double lng = [[point objectForKey:@"lng"] doubleValue];
        [mutableWaypoitns addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lng]];
    }
    self.wayPoints = [wayPointsArray copy];
    
    return self;
}


@end
