//
//  TripServiceDelegate.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TripServiceDelegate <NSObject>

- (void)tripServiceSuccededWithResponse:(NSDictionary*)response;
- (void)tripServiceFailedWithError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END