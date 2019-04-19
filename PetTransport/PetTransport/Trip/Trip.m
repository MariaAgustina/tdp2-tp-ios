//
//  Trip.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (BOOL)hasValidAdresses
{
    return (self.origin && self.destiny);
}

- (BOOL)hasPets
{
    return ([self totalPets] > 0);
}

- (BOOL)isValid
{
    return ([self hasValidAdresses] && [self hasPets]);
}

- (double)totalPets {
    return self.smallPetsQuantity + self.mediumPetsQuantity + self.bigPetsQuantity;
}


- (struct LocationCoordinate)getOriginCoordinate {
    struct LocationCoordinate coordinate;
    coordinate.latitude = self.origin.coordinate.latitude;
    coordinate.longitude = self.origin.coordinate.longitude;
    return coordinate;
}

- (PaymentMethod*)paymentMethodForType:(PaymentMethodType)paymentMethodType {
    
    PaymentMethod *paymentMethod = [PaymentMethod new];
    
    switch(paymentMethodType) {
            case CASH:
            paymentMethod.title = @"Efectivo";
            paymentMethod.paymentKey = @"cash";
            break;
            case CARD:
            paymentMethod.title = @"Tarjeta";
            paymentMethod.paymentKey = @"card";
            break;
            case MERCADOPAGO:
            paymentMethod.title = @"Mercado Pago";
            paymentMethod.paymentKey = @"mp";
            break;
        default:
            paymentMethod.title = @"Efectivo";
            paymentMethod.paymentKey = @"cash";
    }
    
    return paymentMethod;
}

@end
