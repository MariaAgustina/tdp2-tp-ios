//
//  MapDirectionExampleViewController.m
//  PetTransport
//
//  Created by agustina markosich on 5/13/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "DriverRouteViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "LocationManager.h"

@interface DriverRouteViewController () <LocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong,nonatomic) LocationManager *locationManager;

@end

@implementation DriverRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[LocationManager alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    self.mapView.myLocationEnabled = YES;

    [self fetchCurrentLocation];

}

- (void)fetchCurrentLocation {
    [self.locationManager fetchCurrentLocation:self];
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
    
    GMSMutablePath *path = [GMSMutablePath path];

    [path addCoordinate:CLLocationCoordinate2DMake(-34.584991,-58.412257)];
    [path addCoordinate:CLLocationCoordinate2DMake(-34.585696, -58.413139)];
    [path addCoordinate:CLLocationCoordinate2DMake(-34.587215, -58.410997)];
    [path addCoordinate:CLLocationCoordinate2DMake(-34.588039, -58.411563)];
    [path addCoordinate:CLLocationCoordinate2DMake(-34.589054, -58.410139)];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 6.f;
    polyline.map = self.mapView;
}

- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}



@end
