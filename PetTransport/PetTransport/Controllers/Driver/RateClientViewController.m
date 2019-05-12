//
//  RateClientViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RateClientViewController.h"

@interface RateClientViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *fourthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextArea;

@property NSInteger rating;

@end

@implementation RateClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rating = 0;
    
    [self setRateButtonEnabled:NO];
    [self setupView:self.commentsView];
    
    self.commentsTextArea.layer.borderWidth = 1;
    self.commentsTextArea.layer.borderColor =  [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:0.5].CGColor;
    self.commentsTextArea.layer.cornerRadius = 8.0;
    self.commentsTextArea.delegate = self;
}

- (void)setupView:(UIView*)view {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor =  [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:0.5].CGColor;
    view.layer.cornerRadius = 8.0;
}

- (IBAction)firstStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setUnselected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
    self.rating = 1;
}

- (IBAction)secondStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setUnselected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
    self.rating = 2;
}

- (IBAction)thirdStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setUnselected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
    self.rating = 3;
}

- (IBAction)fourthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setUnselected:self.fifthStar];
    [self setRateButtonEnabled:YES];
    self.rating = 4;
}

- (IBAction)fifthStarPressed:(id)sender {
    [self setSelected:self.firstStar];
    [self setSelected:self.secondStar];
    [self setSelected:self.thirdStar];
    [self setSelected:self.fourthStar];
    [self setSelected:self.fifthStar];
    [self setRateButtonEnabled:YES];
    self.rating = 5;
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
    NSLog(@"rating: %ld", self.rating);
    NSLog(@"observacion: %@", self.commentsTextArea.text);
    NSLog(@"rate button pressed");
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger totalLength = [[textView text] length] - range.length + text.length;
    return (totalLength <= 500);
}


@end
