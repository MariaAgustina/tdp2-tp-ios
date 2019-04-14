//
//  RegisterClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterClientViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RegisterClientViewController ()

@property (weak, nonatomic) IBOutlet UIView *formWrapper;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdatePicker;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;

@end

@implementation RegisterClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registro";
    
    self.formWrapper.layer.borderColor = [UIColor blackColor].CGColor;
    self.formWrapper.layer.borderWidth = 1.0f;
    self.firstNameField.text = self.profile.firstName;
    [self.firstNameField setEnabled:NO];
    self.lastNameField.text = self.profile.lastName;
    [self.lastNameField setEnabled:NO];
    [self validateFields];
}

- (IBAction)registerButtonPressed:(id)sender {
    NSLog(@"Registrarme");
}

- (void)validateFields {
    [self.registrationButton setEnabled:NO];
}


@end
