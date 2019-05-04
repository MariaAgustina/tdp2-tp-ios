//
//  DriverMenuViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/21/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverMenuViewController.h"
#import "DriverService.h"
#import "LocationManager.h"
#import "TripOffer.h"

@interface DriverMenuViewController () <DriverServiceDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *availableSwitch;
@property (weak, nonatomic) NSTimer *retryTimer;

@end

@implementation DriverMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DriverService *driverService = [DriverService sharedInstance];
    driverService.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.availableSwitch setOn:NO];
}

- (IBAction)availableSwitchDidChange:(id)sender {
    DriverService *driverService = [DriverService sharedInstance];
    
    //TODO: unificar
    if (self.availableSwitch.on){
        [driverService setWorking];
    } else {
        [driverService setNotWorking];
    }
}

- (void)showNewTrip:(TripOffer*)tripOffer{
    
    //TODO: direcciones en el mensaje
    
    NSString* message =[NSString stringWithFormat:@"%@\r%@", @"Origen: Carrasco 637",@"Destino: Av Paseo Colon 950"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Nuevo viaje encontrado!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        //TODO: Ok action
    }];
    [alert addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Rechazar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // TODO: cancel action
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Driver Service

- (void)driverServiceSuccededWithResponse:(NSDictionary*)response
{
    NSDictionary* tripOfferDictionary = [response objectForKey:@"tripOffer"];
    if(!tripOfferDictionary){
        return;
    }
    
    TripOffer* tripOffer = [[TripOffer alloc] initWithDictionary:tripOfferDictionary];
    if (tripOffer.status == PENDING){
        [self showNewTrip:tripOffer];
    }
}

@end
