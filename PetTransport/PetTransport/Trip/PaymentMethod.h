//
//  PaymentMethod.h
//  PetTransport
//
//  Created by agustina markosich on 4/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentMethod : NSObject

@property (copy,nonatomic) NSString* title;
@property (copy,nonatomic) NSString* paymentKey;

@end

NS_ASSUME_NONNULL_END
