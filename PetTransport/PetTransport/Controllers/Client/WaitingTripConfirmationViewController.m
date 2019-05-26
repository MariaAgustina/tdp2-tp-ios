//
//  WaitingTripConfirmationViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "WaitingTripConfirmationViewController.h"
#import "TrackDriverService.h"
#import "LocationCoordinate.h"
#import "UIViewController+ShowAlerts.h"
#import "TrackDriverViewController.h"
#import "DriverNotFoundViewController.h"

@interface WaitingTripConfirmationViewController () <TrackDriverServideDelegate>

@end

@implementation WaitingTripConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self trackDriver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TrackDriverService sharedInstance] stopTracking];
}

- (void)trackDriver {
    TrackDriverService *service = [TrackDriverService sharedInstance];
    [service startTrackingDriverForTrip:self.trip.tripId WithDelegate:self];
}

- (void)tripConfirmed {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrackDriverViewController *startedTripVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TrackDriverViewController"];
    startedTripVC.trip = self.trip;
    
    [self.navigationController pushViewController:startedTripVC animated:YES];
}

- (void)tripCancelled {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DriverNotFoundViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"DriverNotFoundViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - TrackDriverServiceDelegate

- (void)didUpdateDriverLocation: (struct LocationCoordinate)coordinate andStatus:(DriverStatus)status {
    NSLog(@"Status: %ld", status);
    if (status == DRIVER_STATUS_IN_ORIGIN || status == DRIVER_STATUS_GOING){
        [self tripConfirmed];
    }
    if (status == DRIVER_STATUS_CANCELLED){
        [self tripCancelled];
    }
}

- (void)didFailTracking {
    [self showInternetConexionAlert];
}

@end
