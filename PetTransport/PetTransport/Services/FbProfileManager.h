//
//  FbProfileManager.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/13/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@protocol FbProfileManagerDelegate <NSObject>

- (void)didLoadProfile: (FBSDKProfile *)profile;
- (void)notLoggedInFb;
- (void)didFailedLoadingProfile: (NSError *)error;

@end

@interface FbProfileManager : NSObject

- (instancetype)initWithDelegate: (id<FbProfileManagerDelegate>)delegate;
- (void)loadProfile;

@end
