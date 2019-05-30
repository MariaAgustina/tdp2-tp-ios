//
//  DriverSummary.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverSummary : NSObject

@property (strong,nonatomic) NSString *currentTrips;
@property (strong,nonatomic) NSString *currentMoney;
@property (strong,nonatomic) NSString *previousTrips;
@property (strong,nonatomic) NSString *previousMoney;

- (instancetype)initWithDictionary: (NSDictionary*)dictionary;

@end
