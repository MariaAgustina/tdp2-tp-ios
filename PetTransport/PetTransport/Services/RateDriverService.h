//
//  RateDriverService.h
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateModel.h"
#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RateDriverServiceDelegate <NSObject>

- (void)rateDriverServiceSuccededWithResponse:(NSDictionary*)response;
- (void)rateDriverServiceFailedWithError:(NSError*)error;

@end

@interface RateDriverService : NSObject

- (instancetype)initWithDelegate:(id <RateDriverServiceDelegate>)delegate;
- (void)postRate:(RateModel*)rate trip:(Trip*)trip;

@end

NS_ASSUME_NONNULL_END
