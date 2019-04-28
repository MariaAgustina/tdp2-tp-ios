//
//  DriverMenuViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/21/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverMenuViewController.h"
#import "DriverService.h"

@interface DriverMenuViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *availableSwitch;

@end

@implementation DriverMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.availableSwitch setOn:NO];
}

- (IBAction)availableSwitchDidChange:(id)sender {
    DriverService *driverService = [DriverService sharedInstance];
    if (self.availableSwitch.on){
        [driverService setWorking];
    } else {
        [driverService setNotWorking];
    }
}

@end
