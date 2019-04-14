//
//  TripInformationViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TripInformationViewController.h"

double const kMaximunPetsQuantity = 3;

@interface TripInformationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *smallCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediumCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@property (weak, nonatomic) IBOutlet UIStepper *smallStepper;
@property (weak, nonatomic) IBOutlet UIStepper *mediumStepper;
@property (weak, nonatomic) IBOutlet UIStepper *bigStepper;

@property (assign,nonatomic) double smallPetsQuantity;
@property (assign,nonatomic) double mediumPetsQuantity;
@property (assign,nonatomic) double bigPetsQuantity;
@property (assign,nonatomic) double totalPets;


@end

@implementation TripInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)smallStepperPressed:(UIStepper *)sender {
    self.smallPetsQuantity = sender.value;
    self.smallCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (IBAction)mediumStepperPressed:(UIStepper *)sender {
    self.mediumPetsQuantity = sender.value;
    self.mediumCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (IBAction)bigStepperPressed:(UIStepper *)sender {
    self.bigPetsQuantity = sender.value;
    self.bigCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (void)updateQuantities {
    
    self.totalPets = self.smallPetsQuantity + self.mediumPetsQuantity + self.bigPetsQuantity;
    self.totalCountLabel.text = [NSString stringWithFormat:@"%.0f",self.totalPets];
    
    self.smallStepper.maximumValue = kMaximunPetsQuantity - self.bigStepper.value - self.mediumStepper.value;
    self.mediumStepper.maximumValue = kMaximunPetsQuantity - self.smallStepper.value - self.bigStepper.value;
    self.bigStepper.maximumValue = kMaximunPetsQuantity - self.smallStepper.value - self.mediumStepper.value;

}

@end
