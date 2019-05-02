//
//  ApiClient.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/28/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "ApiClient.h"
#import "AFNetworking.h"
#import "constants.h"

@implementation ApiClient

- (void)postWithRelativeUrlString: (NSString*)relativeUrlString
                             body: (NSDictionary*)body
                            token: (NSString*)token
                          success: (void (^)(id _Nullable))success
                          failure:(void (^)(NSError * _Nonnull, NSInteger statusCode))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_BASE_URL, relativeUrlString];
    
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager POST:urlString parameters: body progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        NSLog(@"Error: %@", error);
        failure(error, httpResponse.statusCode);
    }];
}

@end
