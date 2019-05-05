//
//  RateClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateClientViewController.h"

@interface RateClientViewController ()

@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *fourthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

@end

@implementation RateClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRateButtonEnabled:NO];
}

- (IBAction)firstStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setUnselected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
}

- (IBAction)secondStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
}

- (IBAction)thirdStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
}

- (IBAction)fourthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
}

- (IBAction)fifthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setSelected:self.fifthStar];
    [self setRateButtonEnabled:YES];
}

- (void)setSelected:(UIButton*)star{
    UIImage* fullStarImage = [UIImage imageNamed:@"rating-star-full"];
    [star setBackgroundImage:fullStarImage forState:UIControlStateNormal];
}

- (void)setUnselected:(UIButton*)star{
    UIImage* fullStarImage = [UIImage imageNamed:@"rating-star-empty"];
    [star setBackgroundImage:fullStarImage forState:UIControlStateNormal];
}

- (void)setRateButtonEnabled:(BOOL)enabled{
    self.rateButton.enabled = enabled;
    self.rateButton.backgroundColor = (self.rateButton.enabled) ? [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
}

- (IBAction)rateButtonPressed:(id)sender {
    NSLog(@"rate button pressed");
}

@end
