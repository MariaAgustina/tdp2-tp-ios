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
#import <UserNotifications/UserNotifications.h>
#import "constants.h"
#import "DriverRouteViewController.h"

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
    
    NSString *priceMessage = [NSString stringWithFormat:@"Precio: $%@", trip.cost];
    NSMutableAttributedString *priceLabel = [[NSMutableAttributedString alloc] initWithString:priceMessage];
    [priceLabel addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:16]
                  range:NSMakeRange(0, priceMessage.length)];
    [alert setValue:priceLabel forKey:@"attributedTitle"];
    
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
    NSString *client = [NSString stringWithFormat:@"Cliente: %@", trip.clientName];
    
    NSString *origin = [NSString stringWithFormat:@"Origen: %@", trip.origin.address];
    NSString *destination = [NSString stringWithFormat:@"Destino: %@", trip.destination.address];
    NSString *reservationDate = @"";
    if ([trip isScheduled]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        reservationDate = [NSString stringWithFormat:@"Dia y horario: %@\r", [formatter stringFromDate:trip.scheduleDate]];
    }
    
    NSString *pets = [NSString stringWithFormat:@"Cantidad de mascotas:\r %@", [self getPetsMessage:trip]];
    
    NSString *escort = (trip.bringsEscort) ? @"Sí" : @"No";
    escort = [NSString stringWithFormat:@"¿Con acompañante?: %@", escort];
    
    NSString *comments = (trip.comments && ![trip.comments isEqualToString:@""])
        ? [NSString stringWithFormat:@"\rComentarios: '%@'", trip.comments]
        : @"";
    
    NSString* message =[NSString stringWithFormat:@"%@\r\r%@\r%@\r%@\r%@\r%@\r%@", client, origin, destination, reservationDate, pets, escort, comments];
    return message;
}

- (NSString*)getPetsMessage: (Trip*)trip {
    NSString *bigPets = @"";
    if (trip.bigPetsQuantity > 0){
        bigPets = (trip.bigPetsQuantity == 1) ? @"1 grande" : [NSString stringWithFormat:@"%ld grandes", trip.bigPetsQuantity];
    }
    NSString *mediumPets = @"";
    if (trip.mediumPetsQuantity > 0){
        mediumPets = (trip.mediumPetsQuantity == 1) ? @"1 mediana" : [NSString stringWithFormat:@"%ld medianas", trip.mediumPetsQuantity];
    }
    NSString *smallPets = @"";
    if (trip.smallPetsQuantity > 0){
        smallPets = (trip.smallPetsQuantity == 1) ? @"1 chica" : [NSString stringWithFormat:@"%ld chicas", trip.smallPetsQuantity];
    }
    NSString *message = @"";
    if (trip.bigPetsQuantity > 0){
        message = [bigPets copy];
    }
    if (trip.mediumPetsQuantity > 0){
        message = ([message isEqualToString:@""]) ? [mediumPets copy] : [NSString stringWithFormat:@"%@, %@", message, mediumPets];
    }
    if (trip.smallPetsQuantity > 0){
        message = ([message isEqualToString:@""]) ? [smallPets copy] : [NSString stringWithFormat:@"%@, %@", message, smallPets];
    }
    return message;
}

- (void)scheduleNotification: (Trip*)trip {
    if (![trip isScheduled]){
        return;
    }

    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Recordatorio";
    content.body = [self getNotificationMessage:trip];
    content.sound = [UNNotificationSound defaultSound];

    NSDate *date = [trip.scheduleDate dateByAddingTimeInterval: -1 * REMINDER_TIME_SECONDS];
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
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:notificationIdentifier content:content trigger:trigger];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSString *)getNotificationMessage: (Trip*)trip {
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

- (void)closeAlert{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTripScreen: (Trip *)trip {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DriverRouteViewController *driverTripVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DriverRouteViewController"];
    driverTripVC.trip = trip;
    
    [self.navigationController pushViewController:driverTripVC animated:YES];
}

#pragma mark - Driver Service

- (void)didReceiveTripOffer:(Trip *)trip {
    if ([trip isPending]){
        [self showNewTrip:trip];
        return;
    }
    
    if ([trip isAccepted] && [trip isScheduled]){
        NSLog(@"viaje agendado");
        return;
    }
    
    if ([trip isAccepted] && ![trip isScheduled]){
        [self showTripScreen:trip];
        return;
    }
}
@end
