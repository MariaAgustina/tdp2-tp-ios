//
//  LocationManager.h
//  PetTransport
//
//  Created by Kaoru Heanna on 3/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;
- (void)fetchCurrentLocation;

@end
