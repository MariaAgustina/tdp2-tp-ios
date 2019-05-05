//
//  RegisterPhotoDriverViewController.h
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverProfile.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterPhotoDriverViewController : BaseViewController

@property (strong, nonatomic) DriverProfile *profile;

@end

NS_ASSUME_NONNULL_END
