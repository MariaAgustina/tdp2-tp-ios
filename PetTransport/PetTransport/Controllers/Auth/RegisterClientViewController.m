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
#import <GooglePlaces/GooglePlaces.h>

@interface RegisterClientViewController () <AuthServiceDelegate, GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *formWrapper;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdatePicker;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) AuthService *authService;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdateLabel;

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
    [self showLoading];
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
        self.addressLabel.textColor = [UIColor redColor];
        isValid = NO;
    } else {
        self.addressLabel.textColor = [UIColor blackColor];
    }
    
    if (![self isValidPhoneNumber]){
        self.phoneLabel.textColor = [UIColor redColor];
        isValid = NO;
    } else {
        self.phoneLabel.textColor = [UIColor blackColor];
    }
    
    
    if (![self isValidEmail]){
        self.emailLabel.textColor = [UIColor redColor];
        isValid = NO;
    } else {
        self.emailLabel.textColor = [UIColor blackColor];
    }
    
    if (![self isValidBirthdate]){
        self.birthdateLabel.textColor = [UIColor redColor];
        isValid = NO;
    } else {
        self.birthdateLabel.textColor = [UIColor blackColor];
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
    return [self isValidPhoneNumberWithString:self.phoneField.text];
}

- (BOOL)isValidPhoneNumberWithString:(NSString*)phone {
    NSString *phoneRegex = @"[0-9]{8,12}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

- (BOOL)isValidEmail {
    if (![self isValidText:self.emailField.text]){
        return NO;
    }
    return [self isValidEmailWithString:self.emailField.text];
}

- (BOOL)isValidEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isValidBirthdate {
    NSDate *date = self.birthdatePicker.date;
    return date != nil;
}

- (IBAction)fieldOnChange:(id)sender {
    [self validateFields];
}

- (void)showError: (NSString*)message shouldGoBack:(BOOL)shouldGoBack {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:message
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    if (shouldGoBack){
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addressEditingDidBegin:(id)sender {
    [self presentAutocompleteAdress];
}

- (void)presentAutocompleteAdress {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Specify the place data types to return, other types will be returned as nil.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldCoordinate);
    acController.placeFields = fields;
    
    // Specify a filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    filter.country = @"AR";
    acController.autocompleteFilter = filter;
    
    // Display the autocomplete view controller
    [self presentViewController:acController animated:YES completion:nil];
}

# pragma mark - AuthServiceDelegate methods
- (void)didRegister {
    [self hideLoading];
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Registro exitoso!"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ir a login"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didFailRegistering: (BOOL)duplicatedUser {
    [self hideLoading];
    if (duplicatedUser){
        [self showError:@"El usuario ya estaba registrado" shouldGoBack:YES];
        return;
    }
    [self showError:@"Ups! Falló el registro. Por favor intentá de vuelta más tarde" shouldGoBack:NO];
}

#pragma mark - GMSAutocompleteViewControllerDelegate

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (place){
        self.addressField.text = place.name;
    }
    [self validateFields];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
