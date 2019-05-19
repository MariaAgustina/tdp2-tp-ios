//
//  RateModel.m
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateModel.h"

@implementation RateModel

- (NSString*)getComments {
    if (_comments == nil){
        _comments = @"";
    }
    return _comments;
}

@end
