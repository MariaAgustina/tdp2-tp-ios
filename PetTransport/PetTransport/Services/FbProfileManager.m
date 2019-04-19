//
//  FbProfileManager.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/13/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "FbProfileManager.h"

@interface FbProfileManager ()

@property (nonatomic, weak) id<FbProfileManagerDelegate> delegate;

@end

@implementation FbProfileManager

- (instancetype)initWithDelegate:(id<FbProfileManagerDelegate>)delegate {
    self = [super init];
    self.delegate = delegate;
    return self;
}

- (void)loadProfile {
    [FBSDKProfile loadCurrentProfileWithCompletion:
     ^(FBSDKProfile *profile, NSError *error) {
         if (error != nil){
             NSLog(@"Error loading FB profile: %@", error);
             [self.delegate didFailedLoadingProfile:error];
             return;
         }
         if (profile == nil){
             [self.delegate notLoggedInFb];
             return;
         }
         [self.delegate didLoadProfile:profile];
     }];
}

//NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//[parameters setValue:@"name, first_name, last_name, email" forKey:@"fields"];
//
//[[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
// startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//     if (!error) {
//         NSLog(@"fetched user:%@", result);
//     }
// }];

- (NSString*)getToken {
    if ([FBSDKAccessToken currentAccessToken] == nil){
        return nil;
    }
    NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
    return fbAccessToken;
}

@end
