//
//  RateServiceViewController.m
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateServiceViewController.h"

@interface RateServiceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *fourthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;

@end

@implementation RateServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

- (IBAction)secondStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
}

- (IBAction)thirdStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
}

- (IBAction)fourthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setUnselected:self.fifthStar];
}

- (IBAction)fifthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setSelected:self.fifthStar];
}

@end
