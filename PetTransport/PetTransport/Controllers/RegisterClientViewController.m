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

@interface RegisterClientViewController ()

@end

@implementation RegisterClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registrarme como cliente";
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}



@end
