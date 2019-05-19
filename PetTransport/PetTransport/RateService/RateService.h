//
//  RateService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Trip.h"
#import "RateModel.h"

@interface RateService : NSObject

- (void)rateClient: (RateModel*)rate forTrip:(Trip*)trip;

@end
