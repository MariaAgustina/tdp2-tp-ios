//
//  RegisterClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterClientViewController.h"

@interface RegisterClientViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdatePicker;

@end

@implementation RegisterClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registro";
    
    NSLog(@"name: %@!", self.profile.firstName);
    NSLog(@"lastName: %@!", self.profile.lastName);
    NSLog(@"userId: %@!", self.profile.fbUserId);
    self.firstNameField.text = self.profile.firstName;
    self.lastNameField.text = self.profile.lastName;
    
}


@end
