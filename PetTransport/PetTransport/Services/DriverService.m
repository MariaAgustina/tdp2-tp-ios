//
//  DriverService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/27/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverService.h"

@interface DriverService ()

@property BOOL isWorking;

@end

@implementation DriverService

+ (instancetype)sharedInstance {
    static DriverService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DriverService alloc] init];
    });
    return sharedInstance;
}

- (void)setWorking {
    NSLog(@"trabajando");
    self.isWorking = YES;
}

- (void)setNotWorking {
    NSLog(@"descansando");
    self.isWorking = NO;
}

@end
