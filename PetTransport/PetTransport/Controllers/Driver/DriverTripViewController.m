//
//  DriverTripViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 5/12/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverTripViewController.h"
#import "TripService.h"

@interface DriverTripViewController () <TripServiceDelegate>

@property (strong, nonatomic) TripService *tripService;

@end

@implementation DriverTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Viaje";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tripService = [[TripService alloc] initWithDelegate:self];
    [self.tripService retrieveTripWithId:self.tripId];
}

#pragma mark - TripServiceDelegate methods
- (void)tripServiceFailedWithError:(NSError*)error {
    
}

@end
