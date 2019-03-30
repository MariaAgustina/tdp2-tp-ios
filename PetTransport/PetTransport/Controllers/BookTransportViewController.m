//
//  BookTransportViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 3/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "BookTransportViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationManager.h"

@interface BookTransportViewController () <LocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation BookTransportViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Estoy en Book Transport");
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

@end
