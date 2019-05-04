//
//  ApiClient.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/28/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiClient : NSObject

- (void)postWithRelativeUrlString: (NSString*_Nonnull)relativeUrlString
                             body: (NSDictionary*_Nullable)body
                            token: (NSString*_Nullable)token
                          success: (void (^_Nonnull)(id _Nullable))success
                          failure:(void (^_Nonnull)(NSError * _Nonnull, NSInteger statusCode))failure;

- (void)putWithRelativeUrlString: (NSString*)relativeUrlString
                            body: (NSDictionary*)body
                           token: (NSString*)token
                         success: (void (^)(id _Nullable))success
                         failure:(void (^)(NSError * _Nonnull))failure;
@end
