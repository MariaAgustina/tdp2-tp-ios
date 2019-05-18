//
//  TripInformationViewController.h
//  PetTransport
//
//  Created by agustina markosich on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripRequest.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripInformationViewController : BaseViewController

@property (strong, nonatomic) TripRequest *tripRequest;

@end

NS_ASSUME_NONNULL_END
