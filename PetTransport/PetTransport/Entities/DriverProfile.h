//
//  DriverProfile.h
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "ClientProfile.h"
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "LocationCoordinate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DriverProfile : ClientProfile

@property (strong,nonatomic) UIImage *drivingRecordImage;
@property (strong,nonatomic) UIImage *policyImage;
@property (strong,nonatomic) UIImage *transportImage;
@property struct LocationCoordinate currentLocation;
@property (assign,nonatomic) NSString *status;

@end

NS_ASSUME_NONNULL_END
