//
//  BookTransportViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 3/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "BookTransportViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "LocationManager.h"
#import "Trip.h"
#import "GMSMarker+Setup.h"
#import "TripService.h"
#import "UIViewController+ShowAlerts.h"
#import "TrackDriverViewController.h"

@interface BookTransportViewController () <LocationManagerDelegate, GMSAutocompleteViewControllerDelegate, TripServiceDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSAutocompleteFilter *filter;

@property (strong,nonatomic) Trip* trip;
@property (nonatomic, copy) void (^autocompleteAdressCompletionBlock)(GMSPlace *);

@property (strong,nonatomic) GMSMarker* originMarker;
@property (strong,nonatomic) GMSMarker* destinyMarker;

@property (strong,nonatomic) TripService* service;
@property (strong,nonatomic) LocationManager *locationManager;

@end

@implementation BookTransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pedir viaje";
    self.trip = [Trip new];
    self.originMarker = [GMSMarker new];
    self.destinyMarker = [GMSMarker new];
    self.service = [[TripService alloc]initWithDelegate:self];
    self.locationManager = [[LocationManager alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.myLocationEnabled = YES;
    [self fetchCurrentLocation];
}

- (void)fetchCurrentLocation {
    [self.locationManager fetchCurrentLocation:self];
}


// Present the autocomplete view controller when the button is pressed.

- (void)presentAutocompleteAdressCompletionBlock:(void (^)(GMSPlace *))completionBlock{
    self.autocompleteAdressCompletionBlock = completionBlock;
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Specify the place data types to return, other types will be returned as nil.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldCoordinate);
    acController.placeFields = fields;
    
    // Specify a filter.
    self.filter = [[GMSAutocompleteFilter alloc] init];
    self.filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = self.filter;
    
    // Display the autocomplete view controller
    [self presentViewController:acController animated:YES completion:nil];
}


- (IBAction)originButtonPressed:(id)sender {
    [self presentAutocompleteAdressCompletionBlock: ^(GMSPlace *place) {
        self.trip.origin = place;
        [self.originMarker setupWithPlace:place andMapView:self.mapView];
    }];
}

- (IBAction)destinyButtonPressed:(id)sender {
    [self presentAutocompleteAdressCompletionBlock: ^(GMSPlace *place) {
        self.trip.destiny = place;
        [self.destinyMarker setupWithPlace:place andMapView:self.mapView];
    }];
}

- (IBAction)searchTripButtonPressed:(id)sender {    
    if(![self.trip isValid]){
        //TODO: mensaje de que elija origen y destino
        return;
    }
    [self.service postTrip:self.trip];
}

#pragma mark - LocationManagerDelegate
- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:17];
    
    [self.mapView setCamera:camera];
}

- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}


#pragma mark - GMSAutocompleteViewControllerDelegate

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.autocompleteAdressCompletionBlock(place);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - TripServiceDelegate

- (void)tripServiceSuccededWithResponse:(NSDictionary*)response{
    NSLog(@"response %@",response);
    //TODO: integrar tripId con lo de kao
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
