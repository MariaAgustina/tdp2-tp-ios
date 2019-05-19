//
//  DriverMenuViewController.h
//  PetTransport
//
//  Created by agustina markosich on 4/21/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverProfile.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DriverMenuViewController : BaseViewController

@property (strong, nonatomic) DriverProfile *driver;

@end

NS_ASSUME_NONNULL_END
