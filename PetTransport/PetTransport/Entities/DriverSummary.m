//
//  DriverSummary.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverSummary.h"

@implementation DriverSummary

- (instancetype)initWithDictionary: (NSDictionary*)dictionary {
    self = [super init];
    
    NSDictionary *current = [dictionary objectForKey:@"current"];
    self.currentTrips = [current objectForKey:@"trips"];
    self.currentMoney = [current objectForKey:@"money"];
    
    NSDictionary *previous = [dictionary objectForKey:@"previous"];
    self.previousTrips = [previous objectForKey:@"trips"];
    self.previousMoney = [previous objectForKey:@"money"];
    
    return self;
}

@end
