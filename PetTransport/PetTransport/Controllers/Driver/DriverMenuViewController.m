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
#import <UserNotifications/UserNotifications.h>
#import "constants.h"
#import "DriverTripViewController.h"

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DriverService *driverService = [DriverService sharedInstance];
    driverService.delegate = nil;
}

- (IBAction)availableSwitchDidChange:(id)sender {
    DriverService *driverService = [DriverService sharedInstance];
    
    if (self.availableSwitch.on){
        [driverService setWorking];
    } else {
        [driverService setNotWorking];
    }
}

- (void)showNewTrip:(Trip*)trip{
    
    BOOL isShowingAlert = (self.presentedViewController != nil);
    if(isShowingAlert){
        return;
    }
    
    //Lo pongo en 40 para que se cancele primero del lado del back y no me vuelva a aparecer el cartelito
    [NSTimer scheduledTimerWithTimeInterval:40.0
                                     target:self
                                   selector:@selector(closeAlert)
                                   userInfo:nil
                                    repeats:NO];
    
    NSString* message = [self getOfferMessage:trip];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Nuevo viaje encontrado!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self scheduleNotification:trip];
        [[DriverService sharedInstance] acceptTrip:trip];
    }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Rechazar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [trip reject];
        [[DriverService sharedInstance] rejectTrip:trip];
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)getOfferMessage: (Trip*)trip {
    NSString *origin = [NSString stringWithFormat:@"Origen: %@", trip.origin.address];
    NSString *destination = [NSString stringWithFormat:@"Destino: %@", trip.destination.address];
    NSString *reservationDate = @"";
    if ([trip isScheduled]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        reservationDate = [NSString stringWithFormat:@"Dia y horario: %@\r", [formatter stringFromDate:trip.scheduleDate]];
    }
    
    NSString* message =[NSString stringWithFormat:@"%@\r%@\r%@", origin, destination, reservationDate];
    return message;
}

- (void)scheduleNotification: (Trip*)trip {
    if (![trip isScheduled]){
        return;
    }

    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Recordatorio";
    content.body = [self getOfferMessage:trip];
    content.sound = [UNNotificationSound defaultSound];

    NSDate *date = [trip.scheduleDate dateByAddingTimeInterval: -1 * REMINDER_TIME_SECONDS];
    NSLog(@"schedule date for notification: %@", date);
    if ([date timeIntervalSinceNow] < 0.0) {
        NSLog(@"Falta menos de una hora para el viaje, NO MUESTRO RECORDATORIO");
        return;
    }

    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                     components:NSCalendarUnitYear +
                                     NSCalendarUnitMonth + NSCalendarUnitDay +
                                     NSCalendarUnitHour + NSCalendarUnitMinute +
                                     NSCalendarUnitSecond fromDate:date];
    NSLog(@"scheduling notification: %@", date);
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];


    // Create the request object.
    NSString *notificationIdentifier = [NSString stringWithFormat:@"trip_%ld", trip.tripId];
    UNNotificationRequest* request = [UNNotificationRequest
                                      requestWithIdentifier:notificationIdentifier content:content trigger:trigger];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)closeAlert{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTripScreen: (Trip *)trip {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DriverTripViewController *driverTripVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DriverTripViewController"];
    driverTripVC.tripId = trip.tripId;
    
    [self.navigationController pushViewController:driverTripVC animated:YES];
}

#pragma mark - Driver Service

- (void)didReceiveTripOffer:(Trip *)trip {
    if ([trip isPending]){
        [self showNewTrip:trip];
        return;
    }
    
    if ([trip isAccepted] && ![trip isScheduled]){
//        [self showTripScreen:tripOffer];
//        return;
    }
}

@end
