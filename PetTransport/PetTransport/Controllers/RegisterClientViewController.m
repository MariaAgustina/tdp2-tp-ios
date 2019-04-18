//
//  RegisterClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterClientViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthService.h"

@interface RegisterClientViewController () <AuthServiceDelegate>

@property (weak, nonatomic) IBOutlet UIView *formWrapper;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdatePicker;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) AuthService *authService;

@end

@implementation RegisterClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registro";
    self.authService = [[AuthService alloc] initWithDelegate:self];
    
    self.formWrapper.layer.borderColor = [UIColor blackColor].CGColor;
    self.formWrapper.layer.borderWidth = 1.0f;
    self.firstNameField.text = self.profile.firstName;
    [self.firstNameField setEnabled:NO];
    self.lastNameField.text = self.profile.lastName;
    [self.lastNameField setEnabled:NO];
    [self validateFields];
}

- (IBAction)registerButtonPressed:(id)sender {
    self.profile.address = self.addressField.text;
    self.profile.email = self.emailField.text;
    self.profile.phoneNumber = self.phoneField.text;
    self.profile.birthdate = self.birthdatePicker.date;
    [self.authService registerClient:self.profile];
}

- (void)validateFields {
    BOOL isValid = YES;
    
    if (![self isValidText:self.firstNameField.text]){
        isValid = NO;
    }
    if (![self isValidText:self.lastNameField.text]){
        isValid = NO;
    }
    if (![self isValidText:self.addressField.text]){
        isValid = NO;
    }
    if (![self isValidPhoneNumber]){
        isValid = NO;
    }
    if (![self isValidEmail]){
        isValid = NO;
    }
    if (![self isValidBirthdate]){
        isValid = NO;
    }
    
    [self.registrationButton setEnabled:isValid];
}

- (BOOL)isValidText:(NSString *)text {
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [trimmedText length] > 0;
}

- (BOOL)isValidPhoneNumber {
    if (![self isValidText:self.phoneField.text]){
        return NO;
    }
    // TODO: agregar mask
    return YES;
}

- (BOOL)isValidEmail {
    if (![self isValidText:self.emailField.text]){
        return NO;
    }
    // TODO: agregar mask
    return YES;
}

- (BOOL)isValidBirthdate {
    NSDate *date = self.birthdatePicker.date;
    //TODO
    return YES;
}

- (IBAction)fieldOnChange:(id)sender {
    [self validateFields];
}

# pragma mark - AuthServiceDelegate methods
- (void)didRegisterClient {
    
}

- (void)didFailRegistering {
    
}


@end
