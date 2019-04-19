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

NS_ASSUME_NONNULL_BEGIN

@interface Trip : NSObject

typedef enum paymentMethodsTypes
{
    CASH,
    CARD,
    MERCADOPAGO
} PaymentMethodType;


@property (strong, nonatomic) GMSPlace *origin;
@property (strong, nonatomic) GMSPlace *destiny;

@property (assign, nonatomic) NSInteger tripId;

@property (assign,nonatomic) double smallPetsQuantity;
@property (assign,nonatomic) double mediumPetsQuantity;
@property (assign,nonatomic) double bigPetsQuantity;

@property (assign,nonatomic) BOOL shouldHaveEscolt;
@property (strong,nonatomic) PaymentMethod* selectedPaymentMethod;
@property (copy,nonatomic) NSString* comments;


- (BOOL)hasValidAdresses;
- (BOOL)isValid;
- (struct LocationCoordinate)getOriginCoordinate;
- (double)totalPets;
- (PaymentMethod*)paymentMethodForType:(PaymentMethodType)paymentMethodType;

@end

NS_ASSUME_NONNULL_END
