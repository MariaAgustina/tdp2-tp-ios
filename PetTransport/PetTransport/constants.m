//
//  constants.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/7/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

#define USE_LOCALHOST 0

#if USE_LOCALHOST == 1
NSString* const API_BASE_URL = @"http://localhost:3000";
#else
NSString* const API_BASE_URL = @"http://server7547.herokuapp.com";
#endif

