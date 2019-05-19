//
//  RateService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateModel.h"

@protocol RateServiceDelegate <NSObject>

- (void)rateSuccesful;
- (void)rateFailedWithError:(NSError*)error;

@end


@interface RateService : NSObject

- (instancetype)initWithDelegate:(id<RateServiceDelegate>)delegate;
- (void)rateClient: (RateModel*)rate forTripId:(NSInteger)tripId;

@end
