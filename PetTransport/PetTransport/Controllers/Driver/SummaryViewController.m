//
//  SummaryViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *previousMonthTitle;
@property (weak, nonatomic) IBOutlet UILabel *previousMonthTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousMonthMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthMoneyLabel;


@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonPressed:(id)sender {
}

@end
