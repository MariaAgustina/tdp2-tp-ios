//
//  WayPoints.h
//  PetTransport
//
//  Created by agustina markosich on 5/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WayPoints : NSObject

- (instancetype)initWithDictionary: (NSDictionary*)dictionary;

@property (strong, nonatomic)NSArray<CLLocation*>* points;

@end

NS_ASSUME_NONNULL_END
