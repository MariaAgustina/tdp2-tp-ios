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
#import "FbProfileManager.h"

@interface RegisterClientViewController () <FBSDKLoginButtonDelegate, FbProfileManagerDelegate>

@property (strong, nonatomic) FbProfileManager *fbProfileManager;

@end

@implementation RegisterClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registrarme como cliente";
    
    self.fbProfileManager = [[FbProfileManager alloc] initWithDelegate:self];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    [self loadProfile];
}

- (void)loadProfile {
    [self.fbProfileManager loadProfile];
}

# pragma mark - FBSDKLoginButtonDelegate methods
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    NSLog(@"Login Completed");
    [self loadProfile];
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"Logout");
}

#pragma mark - FbProfileManagerDelegate methods
- (void)didLoadProfile: (FBSDKProfile *)profile {
    NSLog(@"did load profile");
    NSLog(@"name: %@!", profile.firstName);
    NSLog(@"lastName: %@!", profile.lastName);
    NSLog(@"name: %@!", profile.name);
    NSLog(@"userId: %@!", profile.userID);
}

- (void)notLoggedInFb {
    NSLog(@"no estoy logueado en FB");
}

- (void)didFailedLoadingProfile: (NSError *)error {
    NSLog(@"no pude recuperar el profile");
}


@end
