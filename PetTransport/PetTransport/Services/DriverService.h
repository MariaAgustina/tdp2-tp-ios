//
//  DriverService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/27/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DriverServiceDelegate <NSObject>

- (void)driverServiceSuccededWithResponse:(NSDictionary*)response;

@end

@interface DriverService : NSObject

@property (nonatomic, weak) id <DriverServiceDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)setDriverWithToken: (NSString*)token;
- (void)setWorking;
- (void)setNotWorking;
- (void)putStatusWithTripOffer:(NSDictionary*)tripOfferDictionary;

@end
