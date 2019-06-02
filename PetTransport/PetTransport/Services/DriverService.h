//
//  DriverService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/27/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import "DriverSummary.h"

@protocol DriverServiceDelegate <NSObject>

@optional
- (void)didReceiveTripOffer: (Trip*)trip;
- (void)didFailDriverNotAvailable;

@end

@protocol SummaryDelegate <NSObject>

@optional
- (void)didReceiveSummary: (DriverSummary*)summary;

@end

@interface DriverService : NSObject

@property (nonatomic, weak) id <DriverServiceDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)setDriverWithToken: (NSString*)token;
- (void)setWorking;
- (void)setNotWorking;
- (BOOL)isWorking;
- (void)acceptTrip: (Trip*)trip;
- (void)rejectTrip: (Trip*)trip;
- (void)getSummaryWithDelegate: (id<SummaryDelegate>)summaryDelegate;

@end
