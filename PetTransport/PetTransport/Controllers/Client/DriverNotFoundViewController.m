//
//  DriverNotFoundViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/26/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverNotFoundViewController.h"

@interface DriverNotFoundViewController ()

@end

@implementation DriverNotFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

- (IBAction)retryButtonPressed:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:5] animated:YES];
}

- (IBAction)homeButtonPressed:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:2] animated:YES];
}


@end
