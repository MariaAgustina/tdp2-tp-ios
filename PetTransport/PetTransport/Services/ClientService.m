//
//  ClientService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/4/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "ClientService.h"
#import "IdentityService.h"

@interface ClientService ()

@end

@implementation ClientService

+ (instancetype)sharedInstance {
    static ClientService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ClientService alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)setClientWithToken: (NSString*)token {
    IdentityService *identityService = [IdentityService sharedInstance];
    [identityService setAsClient];
    [identityService setToken:token];
}

- (NSString*)getToken {
    return [[IdentityService sharedInstance] getToken];
}

@end
