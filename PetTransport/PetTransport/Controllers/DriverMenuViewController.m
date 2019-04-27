//
//  DriverMenuViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/21/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverMenuViewController.h"

@interface DriverMenuViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *availableSwitch;

@end

@implementation DriverMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)availableSwitchDidChange:(id)sender {
    NSLog(@"availableSwitch did change");
    if (self.availableSwitch.on){
        NSLog(@"esta prendido");
    } else {
        NSLog(@"esta apagado");
    }
}

@end
