//
//  IdentityService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "IdentityService.h"

@interface IdentityService ()

@property (strong, nonatomic) NSString *token;
@property BOOL isDriver;
@property BOOL isClient;

@end

@implementation IdentityService

+ (instancetype)sharedInstance {
    static IdentityService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IdentityService alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    self.isDriver = false;
    self.isClient = false;
    return self;
}

- (void)setAsDriver {
    self.isDriver = YES;
    self.isClient = NO;
}

- (void)setAsClient {
    self.isDriver = NO;
    self.isClient = YES;
}

- (void)setToken: (NSString*)token {
    _token = token;
}

- (NSString*)getToken {
    return _token;
}


@end
