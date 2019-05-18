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
#import "GMSMarker+Setup.h"
#import "TripInformationViewController.h"
#import "TripRequest.h"


@interface BookTransportViewController () <LocationManagerDelegate, GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSAutocompleteFilter *filter;
@property (weak, nonatomic) IBOutlet UIButton *searchTripButton;

@property (strong,nonatomic) TripRequest* tripRequest;
@property (nonatomic, copy) void (^autocompleteAdressCompletionBlock)(GMSPlace *);

@property (strong,nonatomic) GMSMarker* originMarker;
@property (strong,nonatomic) GMSMarker* destinyMarker;

@property (strong,nonatomic) LocationManager *locationManager;

@end

@implementation BookTransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pedir viaje";
    self.tripRequest = [TripRequest new];
    
    self.originMarker = [GMSMarker new];
    self.originMarker.title = @"Origen";
    
    self.destinyMarker = [GMSMarker new];
    self.destinyMarker.title = @"Destino";
    self.destinyMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    
    self.locationManager = [[LocationManager alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.myLocationEnabled = YES;
    [self fetchCurrentLocation];
    [self setupSearchTripButton];
}

- (void)fetchCurrentLocation {
    [self.locationManager fetchCurrentLocation:self];
}

- (void)setupSearchTripButton{
    self.searchTripButton.enabled = [self.tripRequest hasValidAdresses];
    self.searchTripButton.backgroundColor = (self.searchTripButton.enabled) ? [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:85.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
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
    self.filter.country = @"AR";
    acController.autocompleteFilter = self.filter;
    
    // Display the autocomplete view controller
    [self presentViewController:acController animated:YES completion:nil];
}


- (IBAction)originButtonPressed:(id)sender {
    [self presentAutocompleteAdressCompletionBlock: ^(GMSPlace *place) {
        self.tripRequest.origin = place;
        [self.originMarker setupWithPlace:place andMapView:self.mapView];
        [self setupSearchTripButton];
        
        struct LocationCoordinate coordinate;
        coordinate.latitude = place.coordinate.latitude;
        coordinate.longitude = place.coordinate.longitude;
        [self centerCamera:coordinate];
    }];
}

- (IBAction)destinyButtonPressed:(id)sender {
    [self presentAutocompleteAdressCompletionBlock: ^(GMSPlace *place) {
        self.tripRequest.destiny = place;
        [self.destinyMarker setupWithPlace:place andMapView:self.mapView];
        [self setupSearchTripButton];
        
        struct LocationCoordinate coordinate;
        coordinate.latitude = place.coordinate.latitude;
        coordinate.longitude = place.coordinate.longitude;
        [self centerCamera:coordinate];
    }];
}

- (IBAction)searchTripButtonPressed:(id)sender {    
    
    if(![self.tripRequest hasValidAdresses]){
        return;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TripInformationViewController *tripInformationVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TripInformationViewController"];
    tripInformationVC.tripRequest = self.tripRequest;
    
    [self.navigationController pushViewController:tripInformationVC animated:YES];    
    
}

- (void)centerCamera: (struct LocationCoordinate) coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:17];
    [self.mapView setCamera:camera];
}

#pragma mark - LocationManagerDelegate
- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    [self centerCamera:coordinate];
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

@end
