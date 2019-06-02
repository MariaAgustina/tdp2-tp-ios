//
//  constants.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/7/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

#define LOCALHOST 0
#define STAGING 1
#define PROD 2

#define ENV STAGING

#if ENV == LOCALHOST
NSString* const API_BASE_URL = @"http://localhost:3000";
#elif ENV == STAGING
NSString* const API_BASE_URL = @"http://stagingserver7547.herokuapp.com";
#else
NSString* const API_BASE_URL = @"http://server7547.herokuapp.com";
#endif

NSInteger const REMINDER_TIME_SECONDS = 3600;
