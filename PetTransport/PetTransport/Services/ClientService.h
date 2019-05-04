//
//  ClientService.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/4/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientService : NSObject

+ (instancetype)sharedInstance;
- (void)setClientWithToken: (NSString*)token;
- (NSString*)getToken;

@end
