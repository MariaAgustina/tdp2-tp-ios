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


@interface BookTransportViewController () <LocationManagerDelegate, GMSAutocompleteViewControllerDelegate>


@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSAutocompleteFilter *filter;

@property (strong,nonatomic) Trip* trip;
@property (nonatomic, copy) void (^autocompleteCompletionBlock)(GMSPlace *);

@end

@implementation BookTransportViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Estoy en Book Transport");
    self.trip = [Trip new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mapView.myLocationEnabled = YES;
    [self fetchCurrentLocation];
}

- (void)fetchCurrentLocation {
    [[LocationManager sharedInstance] fetchCurrentLocation:self];
}

- (GMSMarker*) addMarker: (struct LocationCoordinate) coordinate {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    marker.title = @"Aca estoy";
    marker.map = self.mapView;
    return marker;
}

// Present the autocomplete view controller when the button is pressed.

- (void)autocompleteClickedCompletionBlock:(void (^)(GMSPlace *))completionBlock{
    self.autocompleteCompletionBlock = completionBlock;
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID);
    acController.placeFields = fields;
    
    // Specify a filter.
    self.filter = [[GMSAutocompleteFilter alloc] init];
    self.filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = self.filter;
    
    // Display the autocomplete view controller
    [self presentViewController:acController animated:YES completion:nil];
}


- (IBAction)originButtonPressed:(id)sender {
    [self autocompleteClickedCompletionBlock: ^(GMSPlace *place) {
        self.trip.origin = place;
    }];
}

- (IBAction)destinyButtonPressed:(id)sender {
    [self autocompleteClickedCompletionBlock: ^(GMSPlace *place) {
        self.trip.destiny = place;
    }];
}

- (IBAction)searchTripButtonPressed:(id)sender {
    NSLog(@"Origen: %@",self.trip.origin.name);
    NSLog(@"Destino: %@",self.trip.destiny.name);
    
    if(![self.trip isValid]){
        //TODO: mensaje de que elija origen y destino
        return;
    }
    //TODO: crear viaje
}

#pragma mark - LocationManagerDelegate
- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:17];
    
    [self.mapView setCamera:camera];
    [self addMarker:coordinate];
}

- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}


#pragma mark - GMSAutocompleteViewControllerDelegate

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place ID %@", place.placeID);
    NSLog(@"Place attributions %@", place.attributions.string);
    self.autocompleteCompletionBlock(place);
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
