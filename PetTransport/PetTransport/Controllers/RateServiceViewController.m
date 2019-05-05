//
//  RateServiceViewController.m
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateServiceViewController.h"
#import "RateModel.h"

@interface RateServiceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *fourthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@property (weak, nonatomic) IBOutlet UIView *improvementView;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *improvementViewHeight;
@property (weak, nonatomic) IBOutlet UISwitch *driverServiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *carServiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *appServiceSwitch;

@property (strong,nonatomic) RateModel* rate;

@end

@implementation RateServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rate = [RateModel new];
    
    [self setImprovementHidden:YES];
    [self setRateButtonEnabled:NO];
    
}

- (void)setSelected:(UIButton*)star{
    UIImage* fullStarImage = [UIImage imageNamed:@"rating-star-full"];
    [star setBackgroundImage:fullStarImage forState:UIControlStateNormal];
}

- (void)setUnselected:(UIButton*)star{
    UIImage* fullStarImage = [UIImage imageNamed:@"rating-star-empty"];
    [star setBackgroundImage:fullStarImage forState:UIControlStateNormal];
}

- (IBAction)firstStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setUnselected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setImprovementHidden:NO];
    [self enableRatebuttonIfShould];
}

- (IBAction)secondStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setImprovementHidden:NO];
    [self enableRatebuttonIfShould];
}

- (IBAction)thirdStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setImprovementHidden:NO];
    [self enableRatebuttonIfShould];
}

- (IBAction)fourthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setImprovementHidden:YES];
    [self setRateButtonEnabled:YES];
}

- (IBAction)fifthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setSelected:self.fifthStar];
    [self setImprovementHidden:YES];
    [self setRateButtonEnabled:YES];

}

- (void)setImprovementHidden:(BOOL)shouldHide{
    self.improvementViewHeight.constant = (shouldHide) ? 0 : 246;
    self.driverServiceSwitch.hidden = shouldHide;
    self.carServiceSwitch.hidden = shouldHide;
    self.appServiceSwitch.hidden = shouldHide;
}

- (void)enableRatebuttonIfShould{
    BOOL shouldEnableRateButton = ((self.rate.driver == YES) || (self.rate.vehicle == YES) || (self.rate.app == YES));
    [self setRateButtonEnabled:shouldEnableRateButton];
}

- (void)setRateButtonEnabled:(BOOL)enabled{
    self.rateButton.enabled = enabled;
    self.rateButton.backgroundColor = (self.rateButton.enabled) ? [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
}

- (IBAction)driverServiceSwitched:(UISwitch *)sender {
    self.rate.driver = sender.on;
    [self enableRatebuttonIfShould];
}

- (IBAction)carServiceSwitched:(UISwitch *)sender {
    self.rate.vehicle = sender.on;
    [self enableRatebuttonIfShould];
}

- (IBAction)applicationServiceSwitched:(UISwitch *)sender {
    self.rate.app = sender.on;
    [self enableRatebuttonIfShould];
}

- (IBAction)rateButtonPressed:(id)sender {
    //TODO
}

@end
