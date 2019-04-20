//
//  RegisterPhotoDriverViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RegisterPhotoDriverViewController.h"

@interface RegisterPhotoDriverViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) UIImagePickerController* imagePickerController;

@property (weak, nonatomic) IBOutlet UIImageView *drivingRecordImageView;
@property (weak, nonatomic) IBOutlet UIImageView *policyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;

@property (nonatomic, copy) void (^setImageBlock)(UIImage *);

@end

@implementation RegisterPhotoDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
}

- (void)presentImagePickerForImageView:(UIImageView*)imageView{
    self.setImageBlock = ^(UIImage *image) {
        imageView.image = image;
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

@end
