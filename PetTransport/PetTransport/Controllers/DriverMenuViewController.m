//
//  DriverMenuViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/21/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverMenuViewController.h"
#import "DriverService.h"
#import "RetryService.h"
#import "LocationManager.h"

@interface DriverMenuViewController () <LocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *availableSwitch;
@property (weak, nonatomic) NSTimer *retryTimer;
@property (strong, nonatomic) RetryService *retryService;

@property (strong,nonatomic) LocationManager *locationManager;

@end

@implementation DriverMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.retryService = [RetryService new];
    [self showNewTrip];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.availableSwitch setOn:NO];
}

- (IBAction)availableSwitchDidChange:(id)sender {
    DriverService *driverService = [DriverService sharedInstance];
    
    //TODO: unificar
    if (self.availableSwitch.on){
        self.driver.status = @"Disponible";
        [driverService setWorking];
        [self startRetrying];
    } else {
        self.driver.status = @"Ocupado";
        [driverService setNotWorking];
    }
}

- (void)startRetrying {
    self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(askForNewTrips)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)askForNewTrips {
    //TODO: cancel pending request
    [self.retryService getTripOffer:self.driver];    
}

- (void)stopRetrying {
    [self.retryTimer invalidate];
    self.retryTimer = nil;
}

- (void)showNewTrip{
    
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

#pragma mark - Location
- (void)startUpdatingLocation {
    self.locationManager = [LocationManager new];
    [self.locationManager startUpdatingLocationWithDelegate:self];
}

- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    self.driver.currentLocation = coordinate;
}


- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}

@end
