//
//  DriverService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/27/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverService : NSObject

+ (instancetype)sharedInstance;
- (void)setDriverWithToken: (NSString*)token;
- (void)setWorking;
- (void)setNotWorking;

@end
