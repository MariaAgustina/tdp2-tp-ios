//
//  TripInformationViewController.m
//  PetTransport
//
//  Created by agustina markosich on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TripInformationViewController.h"
#import "TripService.h"
#import "UIViewController+ShowAlerts.h"
#import "TrackDriverViewController.h"

double const kMaximunPetsQuantity = 3;

@interface TripInformationViewController () <TripServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *smallCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediumCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@property (weak, nonatomic) IBOutlet UIStepper *smallStepper;
@property (weak, nonatomic) IBOutlet UIStepper *mediumStepper;
@property (weak, nonatomic) IBOutlet UIStepper *bigStepper;

@property (weak, nonatomic) IBOutlet UIButton *searchTripButton;

@property (weak, nonatomic) IBOutlet UISwitch *escoltSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentMethodsSegmentControl;

@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;

@property (strong,nonatomic) TripService* service;

@property (weak, nonatomic) IBOutlet UIView *petsView;
@property (weak, nonatomic) IBOutlet UIView *escoltView;
@property (weak, nonatomic) IBOutlet UIView *paymentMethodView;
@property (weak, nonatomic) IBOutlet UIView *commentsView;


@end

@implementation TripInformationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.service = [[TripService alloc]initWithDelegate:self];
    
    self.trip.shouldHaveEscolt = self.escoltSwitch.on;
    self.trip.selectedPaymentMethod = [self.trip paymentMethodForType:CASH];

    [self.paymentMethodsSegmentControl setTitle:[self.trip paymentMethodForType:CASH].title forSegmentAtIndex:CASH];
    [self.paymentMethodsSegmentControl setTitle:[self.trip paymentMethodForType:CARD].title forSegmentAtIndex:CARD];
    [self.paymentMethodsSegmentControl setTitle:[self.trip paymentMethodForType:MERCADOPAGO].title forSegmentAtIndex:MERCADOPAGO];
    
    [self setupView:self.petsView];
    [self setupView:self.escoltView];
    [self setupView:self.paymentMethodView];
    [self setupView:self.commentsView];
    [self setupView:self.commentsTextView];

}

- (void)setupView:(UIView*)view {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor =  [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:0.5].CGColor;
    view.layer.cornerRadius = 8.0;
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupSearchTripButton];
}

- (void)setupSearchTripButton{
    self.searchTripButton.enabled = [self.trip isValid];
    self.searchTripButton.backgroundColor = (self.searchTripButton.enabled) ? [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
}


- (IBAction)smallStepperPressed:(UIStepper *)sender {
    self.trip.smallPetsQuantity = sender.value;
    self.smallCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (IBAction)mediumStepperPressed:(UIStepper *)sender {
    self.trip.mediumPetsQuantity = sender.value;
    self.mediumCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (IBAction)bigStepperPressed:(UIStepper *)sender {
    self.trip.bigPetsQuantity = sender.value;
    self.bigCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (void)updateQuantities {
    
    self.totalCountLabel.text = [NSString stringWithFormat:@"%.0f",[self.trip totalPets]];
    
    self.smallStepper.maximumValue = kMaximunPetsQuantity - self.bigStepper.value - self.mediumStepper.value;
    self.mediumStepper.maximumValue = kMaximunPetsQuantity - self.smallStepper.value - self.bigStepper.value;
    self.bigStepper.maximumValue = kMaximunPetsQuantity - self.smallStepper.value - self.mediumStepper.value;
    
    [self setupSearchTripButton];

}
- (IBAction)escortSwitchPressed:(UISwitch *)sender {
    
    self.trip.shouldHaveEscolt = sender.on;
    
}

- (IBAction)paymentMethodSelected:(UISegmentedControl *)sender {
    self.trip.selectedPaymentMethod = [self.trip paymentMethodForType:(PaymentMethodType)sender.selectedSegmentIndex];
}


- (IBAction)searchTripButtonPressed:(id)sender {
    
    if(![self.trip isValid]){
        return;
    }

    self.trip.comments = self.commentsTextView.text;
    [self.service postTrip:self.trip];
}

#pragma mark - TripServiceDelegate

- (void)tripServiceSuccededWithResponse:(NSDictionary*)response{
    self.trip.tripId = [[response objectForKey:@"id"] integerValue];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrackDriverViewController *startedTripVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TrackDriverViewController"];
    startedTripVC.trip = self.trip;
    
    [self.navigationController pushViewController:startedTripVC animated:YES];
}
- (void)tripServiceFailedWithError:(NSError*)error{
    [self showInternetConexionAlert];
}

@end
