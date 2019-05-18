//
//  TripRequest.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/12/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TripRequest.h"

@implementation TripRequest

- (BOOL)isValid {
    return ([self hasValidAdresses] && [self hasPets]);
}

- (BOOL)hasPets {
    return ([self totalPets] > 0);
}


- (BOOL)hasValidAdresses {
    return (self.origin && self.destiny);
}

- (double)totalPets {
    return self.smallPetsQuantity + self.mediumPetsQuantity + self.bigPetsQuantity;
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
