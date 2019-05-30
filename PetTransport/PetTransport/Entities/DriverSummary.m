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
    self.currentTrips = [[current objectForKey:@"trips"] stringValue];
    self.currentMoney = [[current objectForKey:@"money"] stringValue];
    
    NSDictionary *previous = [dictionary objectForKey:@"previous"];
    self.previousTrips = [[previous objectForKey:@"trips"] stringValue];
    self.previousMoney = [[previous objectForKey:@"money"] stringValue];
    
    return self;
}

@end
