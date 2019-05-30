//
//  SummaryViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "SummaryViewController.h"
#import "DriverService.h"

@interface SummaryViewController () <SummaryDelegate>

@property (weak, nonatomic) IBOutlet UILabel *previousMonthTitle;
@property (weak, nonatomic) IBOutlet UILabel *previousMonthTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousMonthMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthTripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthMoneyLabel;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTitles];
    [self fetchSummary];
}

- (void)fetchSummary {
    DriverService *driverService = [DriverService sharedInstance];
    [driverService getSummaryWithDelegate:self];
}

- (void)updateTitles {
    NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy"];
    
    NSDate *currentDate = [NSDate date];
    NSString *currentMonthNumber = [monthFormatter stringFromDate:currentDate];
    NSString *currentMonthLabel = [self getMonthLabel:currentMonthNumber];
    NSString *currentYearLabel = [yearFormatter stringFromDate:currentDate];
    self.currentMonthTitle.text = [NSString stringWithFormat:@"%@ - %@", currentMonthLabel, currentYearLabel];
    
    NSDate *previousMonthDate = [self getPreviousMonth];
    NSString *previousMonthNumber = [monthFormatter stringFromDate:previousMonthDate];
    NSString *previousMonthLabel = [self getMonthLabel:previousMonthNumber];
    NSString *previousYearLabel = [yearFormatter stringFromDate:previousMonthDate];
    self.previousMonthTitle.text = [NSString stringWithFormat:@"%@ - %@", previousMonthLabel, previousYearLabel];
}

- (NSDate*)getPreviousMonth {
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate *lastMonth = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    return lastMonth;
}

- (NSString*)getMonthLabel: (NSString*)monthNumber {
    NSDictionary *months = @{
                             @"01": @"Enero",
                             @"02": @"Febrero",
                             @"03": @"Marzo",
                             @"04": @"Abril",
                             @"05": @"Mayo",
                             @"06": @"Junio",
                             @"07": @"Julio",
                             @"08": @"Agosto",
                             @"09": @"Septiembre",
                             @"10": @"Octubre",
                             @"11": @"Noviembre",
                             @"12": @"Diciembre",
                             };
    return [months objectForKey:monthNumber];
}

- (IBAction)buttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveSummary:(DriverSummary *)summary {
    self.currentMonthTripsLabel.text = summary.currentTrips;
    self.currentMonthMoneyLabel.text = [NSString stringWithFormat:@"$%@", summary.currentMoney];
    
    self.previousMonthTripsLabel.text = summary.previousTrips;
    self.previousMonthMoneyLabel.text = [NSString stringWithFormat:@"$%@", summary.previousMoney];
}

@end
