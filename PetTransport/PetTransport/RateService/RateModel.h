//
//  RateModel.h
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RateModel : NSObject

@property (nonatomic) BOOL driver;
@property (nonatomic) BOOL app;
@property (nonatomic) BOOL vehicle;
@property (nonatomic) NSInteger rating;
@property (strong, nonatomic) NSString *comments;

@end

NS_ASSUME_NONNULL_END
