//
//  RequireTripViewController.h
//  PetTransport
//
//  Created by agustina markosich on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "BaseViewController.h"
#import "TripRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequireTripViewController : BaseViewController

@property (strong,nonatomic) TripRequest* tripRequest;
@property (strong,nonatomic) NSString* price;

@end

NS_ASSUME_NONNULL_END
