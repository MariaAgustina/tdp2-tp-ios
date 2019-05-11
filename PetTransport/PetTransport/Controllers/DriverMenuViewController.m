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
    
    if (self.availableSwitch.on){
        [driverService setWorking];
    } else {
        [driverService setNotWorking];
    }
}

- (void)showNewTrip:(TripOffer*)tripOffer{
    
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
    
    NSString* message = [self getOfferMessage:tripOffer];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Nuevo viaje encontrado!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self scheduleNotification:tripOffer];
        NSDictionary* params = [tripOffer updateDictionaryForStatus:ACCEPTED];
        [[DriverService sharedInstance] putStatusWithTripOffer:params];
    }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Rechazar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        NSDictionary* params = [tripOffer updateDictionaryForStatus:REJECTED];
        [[DriverService sharedInstance] putStatusWithTripOffer:params];
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)getOfferMessage: (TripOffer*)tripOffer {
    NSString *origin = [NSString stringWithFormat:@"Origen: %@", tripOffer.originAddress];
    NSString *destination = [NSString stringWithFormat:@"Destion: %@", tripOffer.destinationAddress];
    NSString *reservationDate = @"";
    if ([tripOffer isScheduled]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        reservationDate = [NSString stringWithFormat:@"Dia y horario: %@\r", [formatter stringFromDate:tripOffer.scheduleDate]];
    }
    
    NSString* message =[NSString stringWithFormat:@"%@\r%@\r%@", origin, destination, reservationDate];
    return message;
}

- (void)scheduleNotification: (TripOffer*)tripOffer {
    if (![tripOffer isScheduled]){
        return;
    }
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Recordatorio";
    content.body = [self getOfferMessage:tripOffer];
    content.sound = [UNNotificationSound defaultSound];
    
    NSDate *date = [tripOffer.scheduleDate dateByAddingTimeInterval: -1 * REMINDER_TIME_SECONDS];
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
    NSString *notificationIdentifier = [NSString stringWithFormat:@"trip_%ld", tripOffer.tripId];
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
