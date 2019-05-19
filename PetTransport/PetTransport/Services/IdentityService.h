//
//  IdentityService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityService : NSObject

+ (instancetype)sharedInstance;
- (void)setAsDriver;
- (void)setAsClient;
- (void)setToken: (NSString*)token;
- (NSString*)getToken;

@end
