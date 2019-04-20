//
//  DriverProfile.h
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "ClientProfile.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DriverProfile : ClientProfile

@property (strong,nonatomic) UIImage *drivingRecordImage;
@property (strong,nonatomic) UIImage *policyImage;
@property (strong,nonatomic) UIImage *transportImage;

@end

NS_ASSUME_NONNULL_END
