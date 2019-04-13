//
//  RegisterClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/13/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterClientViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface RegisterClientViewController () <FBSDKLoginButtonDelegate>

@end

@implementation RegisterClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registrarme como cliente";
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}

- (void)loadProfile {
    [FBSDKProfile loadCurrentProfileWithCompletion:
     ^(FBSDKProfile *profile, NSError *error) {
         if (profile) {
             NSLog(@"Hello, %@!", profile.firstName);
             NSLog(@"middleName: %@!", profile.middleName);
             NSLog(@"middleName: %@!", profile.middleName);
             NSLog(@"lastName: %@!", profile.lastName);
             NSLog(@"name: %@!", profile.name);
             NSLog(@"userId: %@!", profile.userID);
         }
     }];
}

# pragma mark - FBSDKLoginButtonDelegate
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    NSLog(@"Login Completed");
    [self loadProfile];
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"Logout");
}



@end
