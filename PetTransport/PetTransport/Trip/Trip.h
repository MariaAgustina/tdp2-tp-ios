//
//  Trip.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationCoordinate.h"
#import "PaymentMethod.h"
#import "PTLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Trip : NSObject

@property (assign, nonatomic) NSInteger tripId;

@property (strong,nonatomic) PTLocation *origin;
@property (strong,nonatomic) PTLocation *destination;

@property (assign,nonatomic) NSInteger smallPetsQuantity;
@property (assign,nonatomic) NSInteger mediumPetsQuantity;
@property (assign,nonatomic) NSInteger bigPetsQuantity;

@property (assign,nonatomic) BOOL bringsEscort;
@property (strong,nonatomic) PaymentMethod* paymentMethod;
@property (copy,nonatomic) NSString* comments;
@property (strong, nonatomic) NSDate *scheduleDate;
@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *clientName;
@property (assign, nonatomic) NSInteger clientId;

@property (strong, nonatomic) NSString *driverName;
@property (strong, nonatomic) NSString *driverPhone;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)toDictionary;
- (struct LocationCoordinate)getOriginCoordinate;
- (BOOL)isScheduled;
- (BOOL)isPending;
- (BOOL)isAccepted;
- (BOOL)isRejected;
- (void)accept;
- (void)reject;
- (BOOL)isGoingToPickup;
- (BOOL)isAtOrigin;
- (BOOL)isTravelling;
- (BOOL)isAtDestination;
- (BOOL)isFinished;
- (NSString*)getStatusName;

@end

NS_ASSUME_NONNULL_END
