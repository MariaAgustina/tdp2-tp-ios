//
//  TripRequest.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/12/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LocationCoordinate.h"
#import "PaymentMethod.h"


@interface TripRequest : NSObject

@property (strong, nonatomic) GMSPlace *origin;
@property (strong, nonatomic) GMSPlace *destiny;

@property (assign,nonatomic) double smallPetsQuantity;
@property (assign,nonatomic) double mediumPetsQuantity;
@property (assign,nonatomic) double bigPetsQuantity;

@property (assign,nonatomic) BOOL shouldHaveEscort;
@property (strong,nonatomic) PaymentMethod* selectedPaymentMethod;
@property (copy,nonatomic) NSString* comments;
@property (strong, nonatomic) NSDate *scheduleDate;

- (BOOL)isValid;
- (BOOL)hasValidAdresses;
- (double)totalPets;
- (PaymentMethod*)paymentMethodForType:(PaymentMethodType)paymentMethodType;

@end
