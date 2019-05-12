//
//  PTLocation.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/12/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationCoordinate.h"

@interface PTLocation : NSObject

@property (strong, nonatomic) NSString *address;
@property struct LocationCoordinate coordinate;

- (instancetype)initWithDictionary: (NSDictionary*)dictionary;

@end
