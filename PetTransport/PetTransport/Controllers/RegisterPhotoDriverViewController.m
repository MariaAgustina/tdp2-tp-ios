//
//  RegisterPhotoDriverViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterPhotoDriverViewController.h"
#import "DriverAuthService.h"

@interface RegisterPhotoDriverViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,AuthServiceDelegate>

@property (strong,nonatomic) UIImagePickerController* imagePickerController;

@property (weak, nonatomic) IBOutlet UIImageView *drivingRecordImageView;
@property (weak, nonatomic) IBOutlet UIImageView *policyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;

@property (nonatomic, copy) void (^setImageBlock)(UIImage *);

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) DriverAuthService *authService;

@end

@implementation RegisterPhotoDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.authService = [[DriverAuthService alloc] initWithDelegate:self];

    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self.drivingRecordImageView setHighlighted:YES];
    [self.policyImageView setHighlighted:YES];
    [self.transportImageView setHighlighted:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    [self updateRegisterButton];
}

- (void)updateRegisterButton
{
    BOOL shouldEnableRegisterButton = ((self.drivingRecordImageView.image != nil) && (self.policyImageView.image != nil) && (self.transportImageView.image != nil));
    self.registerButton.enabled = shouldEnableRegisterButton;
}

- (void)presentImagePickerForImageView:(UIImageView*)imageView{

    __weak typeof(self) weakSelf = self;

    self.setImageBlock = ^(UIImage *image) {
        imageView.image = image;
        [imageView setHighlighted:NO];
        [weakSelf updateRegisterButton];
    };
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)drivingRecordPhotoButtonPressed:(id)sender {
    [self presentImagePickerForImageView:self.drivingRecordImageView];
}

- (IBAction)insurancePhotoButtonPressed:(id)sender {
    [self presentImagePickerForImageView:self.policyImageView];
}

- (IBAction)transportPhotoButtonPressed:(id)sender {
    [self presentImagePickerForImageView:self.transportImageView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.setImageBlock(chosenImage);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButtonPressed:(id)sender {
    self.profile.drivingRecordImage = self.drivingRecordImageView.image;
    self.profile.policyImage = self.policyImageView.image;
    self.profile.transportImage = self.transportImageView.image;
    
    [self.authService registerDriver:self.profile];
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


# pragma mark - AuthServiceDelegate methods
- (void)didRegisterClient {
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
    if (duplicatedUser){
        [self showError:@"El usuario ya estaba registrado" shouldGoBack:YES];
        return;
    }
    [self showError:@"Ups! Falló el registro. Por favor intentá de vuelta más tarde" shouldGoBack:NO];
}

@end
