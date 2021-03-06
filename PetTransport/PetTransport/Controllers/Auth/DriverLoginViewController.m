//
//  DriverLoginViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FbProfileManager.h"
#import "RegisterClientViewController.h"
#import "AuthService.h"
#import "DriverService.h"
#import "DriverMenuViewController.h"
#import "BaseViewController.h"

@interface DriverLoginViewController () <FbProfileManagerDelegate, AuthServiceDelegate>

@property (strong, nonatomic) FbProfileManager *fbProfileManager;
@property (strong, nonatomic) AuthService *authService;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) NSString *pendingAction;

@end

@implementation DriverLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
    
    self.fbProfileManager = [[FbProfileManager alloc] initWithDelegate:self];
    self.authService = [[AuthService alloc] initWithDelegate:self];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self showLoading];
    self.pendingAction = @"Login";
    if ([self.fbProfileManager getToken] == nil){
        [self loginInFacebook];
        return;
    }
    [self login];
}

- (void)login {
    NSString *fbToken = [self.fbProfileManager getToken];
    [self.authService loginDriver:fbToken];
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
    DriverProfile *driverProfile = [DriverProfile new];
    driverProfile.fbUserId = profile.userID;
    driverProfile.firstName = profile.firstName;
    driverProfile.lastName = profile.lastName;
    driverProfile.fbToken = [self.fbProfileManager getToken];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterClientViewController *registerClientVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterDriverViewController"];
    
    registerClientVC.profile = driverProfile;
    [self.navigationController pushViewController:registerClientVC animated:YES];
}

- (void)showFbLoginError {
    [self showError:@"Error al identificarse con Facebook"];
}

- (void)showError: (NSString*)message {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:message
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


#pragma mark - FbProfileManagerDelegate methods
- (void)didLoadProfile: (FBSDKProfile *)profile {
    if ([self.pendingAction isEqualToString:@"Registration"]){
        [self goToRegistrationScreen: profile];
        return;
    }
    
    if ([self.pendingAction isEqualToString:@"Login"]){
        [self login];
        return;
    }
}

- (void)notLoggedInFb {
    [self loginInFacebook];
}

- (void)didFailedLoadingProfile: (NSError *)error {
    [self showFbLoginError];
}

# pragma mark - AuthServiceDelegate methods
- (void)didLoginWithProfile:(DriverProfile*)profile{
    [self hideLoading];
    [[DriverService sharedInstance] setDriverWithToken:profile.fbToken];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DriverMenuViewController *driverMenuVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DriverMenuViewController"];
    driverMenuVC.driver = profile;
    
    [self.navigationController pushViewController:driverMenuVC animated:YES];
}

- (void)didFailLogin: (BOOL)inexistentUser {
    [self hideLoading];
    if (inexistentUser){
        self.pendingAction = @"Registration";
        [self loadProfile];
        return;
    }
    [self showError:@"Error al loguearse"];
}

@end
