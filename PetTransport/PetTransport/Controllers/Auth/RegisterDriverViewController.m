//
//  RegisterDriverViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterDriverViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegisterPhotoDriverViewController.h"
#import <GooglePlaces/GooglePlaces.h>

@interface RegisterDriverViewController () <GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *formWrapper;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdatePicker;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdateLabel;


@end

@implementation RegisterDriverViewController

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
    
    self.profile.address = self.addressField.text;
    self.profile.email = self.emailField.text;
    self.profile.phoneNumber = self.phoneField.text;
    self.profile.birthdate = self.birthdatePicker.date;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterPhotoDriverViewController *registerPhotoVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterPhotoDriverViewController"];
    registerPhotoVC.profile = self.profile;
    
    [self.navigationController pushViewController:registerPhotoVC animated:YES];
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
