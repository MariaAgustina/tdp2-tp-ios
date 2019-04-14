//
//  RegisterClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/13/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "FacebookViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FbProfileManager.h"
#import "RegisterClientViewController.h"
#import "ClientProfile.h"

@interface FacebookViewController () <FBSDKLoginButtonDelegate, FbProfileManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *customFbButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbButton;
@property (strong, nonatomic) FbProfileManager *fbProfileManager;

@end

@implementation FacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Facebook";
    
    self.fbProfileManager = [[FbProfileManager alloc] initWithDelegate:self];
    
    self.fbButton.delegate = self;
    [self.fbButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"logueate fiera"]
                                forState:UIControlStateNormal];
    
    [self loadProfile];
}

- (void)loadProfile {
    [self.fbProfileManager loadProfile];
}

- (IBAction)customFbButtonPressed:(id)sender {
    NSLog(@"CUSTOM BUTTON PRESSED");
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self loadProfile];
         }
     }];
}

- (void)goToRegistrationScreen:(FBSDKProfile *)profile {
    ClientProfile *clientProfile = [ClientProfile new];
    clientProfile.fbUserId = profile.userID;
    clientProfile.firstName = profile.firstName;
    clientProfile.lastName = profile.lastName;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterClientViewController *registerClientVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterClientViewController"];
    
    registerClientVC.profile = clientProfile;
    [self.navigationController pushViewController:registerClientVC animated:YES];
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
    [self goToRegistrationScreen: profile];
}

- (void)notLoggedInFb {
    NSLog(@"no estoy logueado en FB");
}

- (void)didFailedLoadingProfile: (NSError *)error {
    NSLog(@"no pude recuperar el profile");
}


@end
