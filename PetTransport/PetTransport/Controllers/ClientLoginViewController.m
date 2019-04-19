//
//  ClientLoginViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/18/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "ClientLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FbProfileManager.h"
#import "RegisterClientViewController.h"
#import "ClientProfile.h"


@interface ClientLoginViewController () <FBSDKLoginButtonDelegate, FbProfileManagerDelegate>

@property (strong, nonatomic) FbProfileManager *fbProfileManager;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) NSString *pendingAction;

@end

@implementation ClientLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
    
    self.fbProfileManager = [[FbProfileManager alloc] initWithDelegate:self];
}

- (IBAction)loginButtonPressed:(id)sender {
    self.pendingAction = @"Login";
}

- (IBAction)registrationButtonPressed:(id)sender {
    self.pendingAction = @"Registration";
    [self loadProfile];
}

- (void)loadProfile {
    if ([self.fbProfileManager getToken] == nil){
        [self loginInFacebook];
        return;
    }
    [self.fbProfileManager loadProfile];
}

- (void)loginInFacebook {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             [self showFbLoginError];
         } else if (result.isCancelled) {
             [self showFbLoginError];
         } else {
             [self loadProfile];
         }
     }];
}

- (void)goToRegistrationScreen:(FBSDKProfile *)profile {
    ClientProfile *clientProfile = [ClientProfile new];
    clientProfile.fbUserId = profile.userID;
    clientProfile.firstName = profile.firstName;
    clientProfile.lastName = profile.lastName;
    clientProfile.fbToken = [self.fbProfileManager getToken];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterClientViewController *registerClientVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterClientViewController"];
    
    registerClientVC.profile = clientProfile;
    [self.navigationController pushViewController:registerClientVC animated:YES];
}

- (void)showFbLoginError {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error al identificarse con Facebook"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark - FBSDKLoginButtonDelegate methods
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    NSLog(@"Login Completed");
    //[self loadProfile];
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"Logout");
}

#pragma mark - FbProfileManagerDelegate methods
- (void)didLoadProfile: (FBSDKProfile *)profile {
    NSLog(@"didLoadProfile");
    
    if ([self.pendingAction isEqualToString:@"Registration"]){
        [self goToRegistrationScreen: profile];
    }
}

- (void)notLoggedInFb {
    [self loginInFacebook];
}

- (void)didFailedLoadingProfile: (NSError *)error {
    [self showFbLoginError];
}


@end
