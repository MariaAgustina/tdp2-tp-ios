//
//  RetryService.h
//  PetTransport
//
//  Created by agustina markosich on 5/1/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface RetryService : NSObject

- (void)getTripOffer:(DriverProfile*)driverProfile;

@end

NS_ASSUME_NONNULL_END
