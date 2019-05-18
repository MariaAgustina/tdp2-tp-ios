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
#import "WaitingTripConfirmationViewController.h"

double const kMaximunPetsQuantity = 3;

@interface TripInformationViewController () <TripServiceDelegate,UITextViewDelegate>

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
@property (weak, nonatomic) IBOutlet UIView *timeSelectionView;

@property (weak, nonatomic) IBOutlet UISwitch *timeSelectionSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeSelectionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerHeightConstraint;

@end

@implementation TripInformationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.service = [[TripService alloc] initWithDelegate:self];
    
    self.tripRequest.shouldHaveEscort = self.escoltSwitch.on;
    self.tripRequest.selectedPaymentMethod = [self.tripRequest paymentMethodForType:CASH];
    self.tripRequest.smallPetsQuantity = self.smallStepper.value;
    self.tripRequest.mediumPetsQuantity = self.mediumStepper.value;
    self.tripRequest.bigPetsQuantity = self.bigStepper.value;
    self.tripRequest.comments = self.commentsTextView.text;
    
    [self.paymentMethodsSegmentControl setTitle:[self.tripRequest paymentMethodForType:CASH].title forSegmentAtIndex:CASH];
    [self.paymentMethodsSegmentControl setTitle:[self.tripRequest paymentMethodForType:CARD].title forSegmentAtIndex:CARD];
    [self.paymentMethodsSegmentControl setTitle:[self.tripRequest paymentMethodForType:MERCADOPAGO].title forSegmentAtIndex:MERCADOPAGO];
    
    self.commentsTextView.delegate = self;
    
    [self configDatePicker];
    
    [self setupView:self.petsView];
    [self setupView:self.escoltView];
    [self setupView:self.paymentMethodView];
    [self setupView:self.commentsView];
    [self setupView:self.commentsTextView];
    [self setupView:self.timeSelectionView];
}

- (void)setupView:(UIView*)view {
    view.layer.borderWidth = 0.5;
    view.layer.borderColor =  [UIColor colorWithRed:220/255 green:220/255 blue:220/255 alpha:0.5].CGColor;
    view.layer.cornerRadius = 8.0;
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateTimeSelectionView];
    [self setupSearchTripButton];
}

- (void)setupSearchTripButton{
    self.searchTripButton.enabled = [self.tripRequest isValid];
    self.searchTripButton.backgroundColor = (self.searchTripButton.enabled) ? [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
}

- (IBAction)smallStepperPressed:(UIStepper *)sender {
    self.tripRequest.smallPetsQuantity = sender.value;
    self.smallCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (IBAction)mediumStepperPressed:(UIStepper *)sender {
    self.tripRequest.mediumPetsQuantity = sender.value;
    self.mediumCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (IBAction)bigStepperPressed:(UIStepper *)sender {
    self.tripRequest.bigPetsQuantity = sender.value;
    self.bigCountLabel.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [self updateQuantities];
}

- (void)updateQuantities {
    
    self.totalCountLabel.text = [NSString stringWithFormat:@"%.0f",[self.tripRequest totalPets]];
    
    self.smallStepper.maximumValue = kMaximunPetsQuantity - self.bigStepper.value - self.mediumStepper.value;
    self.mediumStepper.maximumValue = kMaximunPetsQuantity - self.smallStepper.value - self.bigStepper.value;
    self.bigStepper.maximumValue = kMaximunPetsQuantity - self.smallStepper.value - self.mediumStepper.value;
    
    [self setupSearchTripButton];

}
- (IBAction)escortSwitchPressed:(UISwitch *)sender {
    self.tripRequest.shouldHaveEscort = sender.on;
}

- (IBAction)paymentMethodSelected:(UISegmentedControl *)sender {
    self.tripRequest.selectedPaymentMethod = [self.tripRequest paymentMethodForType:(PaymentMethodType)sender.selectedSegmentIndex];
}

- (BOOL)isScheduleTripActivated {
    return self.timeSelectionSwitch.on;
}

- (IBAction)searchTripButtonPressed:(id)sender {
    if(![self.tripRequest isValid]){
        return;
    }

    [self showLoading];
    self.tripRequest.comments = self.commentsTextView.text;
    self.tripRequest.scheduleDate = [self isScheduleTripActivated] ? self.datePicker.date : nil;
    
    [self.service sendTripRequest:self.tripRequest];
}

- (void)configDatePicker {
    NSDate *now = [NSDate date];
    [self.datePicker setMinimumDate:now];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *maxDate = [theCalendar dateByAddingComponents:dayComponent toDate:now options:0];
    [self.datePicker setMaximumDate:maxDate];
}

- (IBAction)timeSelectionSwitchChanged:(id)sender {
    [self updateTimeSelectionView];
}

- (void)updateTimeSelectionView {
    if ([self isScheduleTripActivated]) {
        self.timeSelectionLabel.text = @"Programar viaje para";
        self.datePicker.hidden = NO;
        self.datePickerHeightConstraint.constant = 200;
        [self.view updateConstraints];
        return;
    }
    self.timeSelectionLabel.text = @"Quiero viajar ahora";
    self.datePicker.hidden = YES;
    self.datePickerHeightConstraint.constant = 0;
    [self.view updateConstraints];
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

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return ([[textView text] length] - range.length + text.length < 250);
}

@end