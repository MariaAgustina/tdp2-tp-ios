//
//  RequireTripViewController.m
//  PetTransport
//
//  Created by agustina markosich on 5/19/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "RequireTripViewController.h"
#import "WaitingTripConfirmationViewController.h"
#import "UIViewController+ShowAlerts.h"
#import "TripService.h"

@interface RequireTripViewController () <TripServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *originAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *petsQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *comentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *bringsScortLabel;

@property (strong,nonatomic) TripService* service;

@end

@implementation RequireTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[TripService alloc] initWithDelegate:self];

    self.originAddressLabel.text = self.tripRequest.origin.name;
    self.destinationAddressLabel.text = self.tripRequest.destiny.name;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/mm/yyyy HH:mm"];
    self.dateLabel.text = (self.tripRequest.scheduleDate) ? [formatter stringFromDate:self.tripRequest.scheduleDate] : @"Ahora";
    
    self.petsQuantityLabel.text = [self getPetsQuantityString];
    self.comentsLabel.text = (![self.tripRequest.comments isEqualToString:@""]) ? self.tripRequest.comments : @"-";
    
    self.bringsScortLabel.text = (self.tripRequest.shouldHaveEscort) ? @"Sí" : @"No";
    self.paymentMethodLabel.text = self.tripRequest.selectedPaymentMethod.title;
    
    self.priceLabel.text = self.price;
    
}

-(NSString*)getPetsQuantityString{
    
    NSString* bigPetsString;
    if(self.tripRequest.bigPetsQuantity == 1){
        bigPetsString = @"1 grande";
    }else if(self.tripRequest.bigPetsQuantity == 2){
        bigPetsString = @"2 grandes";
    }else if(self.tripRequest.bigPetsQuantity == 3){
        bigPetsString = @"3 grandes";
    }
    
    NSString* mediumPetsString;
    if(self.tripRequest.mediumPetsQuantity == 1){
        mediumPetsString = @"1 mediana";
    }else if(self.tripRequest.mediumPetsQuantity == 2){
        mediumPetsString = @"2 medianas";
    }else if(self.tripRequest.mediumPetsQuantity == 3){
        mediumPetsString = @"3 medianas";
    }
    
    NSString* smallPetsString;
    if(self.tripRequest.smallPetsQuantity == 1){
        smallPetsString = @"1 chica";
    }else if(self.tripRequest.smallPetsQuantity == 2){
        smallPetsString = @"2 chicas";
    }else if(self.tripRequest.smallPetsQuantity == 3){
        smallPetsString = @"3 chicas";
    }
    
    NSString* result = @" ";
    if(bigPetsString){
        result = [result stringByAppendingString:bigPetsString];
    }
    if(mediumPetsString){
        result = [result stringByAppendingString:@" "];
        result = [result stringByAppendingString:mediumPetsString];
    }
    if(smallPetsString){
        result = [result stringByAppendingString:@" "];
        result = [result stringByAppendingString:smallPetsString];
    }
    return result;
}

- (IBAction)confirmButtonPressed:(id)sender {
    [self showLoading];
    [self.service sendTripRequest:self.tripRequest];

}

- (IBAction)cancelButtonPressed:(id)sender {
    NSUInteger ownIndex = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:ownIndex - 2] animated:YES];
}

#pragma mark - TripServiceDelegate

- (void)didReturnTrip:(Trip *)trip {
    [self hideLoading];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WaitingTripConfirmationViewController *startedTripVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WaitingTripConfirmationViewController"];
    startedTripVC.trip = trip;
    
    [self.navigationController pushViewController:startedTripVC animated:YES];
}

- (void)tripServiceFailedWithError:(NSError*)error{
    [self hideLoading];
    [self showInternetConexionAlert];
}


@end
