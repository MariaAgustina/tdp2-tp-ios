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
#import "GMSMarker+Setup.h"
#import "CoordinateAddapter.h"
#import "RoutesService.h"

@interface DriverRouteViewController () <LocationManagerDelegate, RoutesServiceDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong,nonatomic) LocationManager *locationManager;

@property (strong,nonatomic) GMSMarker* originMarker;
@property (strong,nonatomic) GMSMarker* destinyMarker;

@property (strong,nonatomic) RoutesService* routesService;

@end

@implementation DriverRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[LocationManager alloc] init];
    
    [self setupOriginAndDestinationMarkers];
    
    self.routesService = [[RoutesService alloc] initWithDelegate:self];
    [self.routesService getTripCoordinates:self.trip];
}

- (void)setupOriginAndDestinationMarkers
{
    self.originMarker = [GMSMarker new];
    self.originMarker.title = @"Origen";
    CLLocationCoordinate2D origin = [CoordinateAddapter getCoordinate:self.trip.origin.coordinate];
    [self.originMarker setupWithCoordinate:origin address:self.trip.origin.address andMapView:self.mapView];

    self.destinyMarker = [GMSMarker new];
    self.destinyMarker.title = @"Destino";
    self.destinyMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    CLLocationCoordinate2D destination = [CoordinateAddapter getCoordinate:self.trip.destination.coordinate];
    [self.destinyMarker setupWithCoordinate:destination address:self.trip.destination.address andMapView:self.mapView];
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

- (void)succededReceivingRoute:(WayPoints*)coordinates{
    //TODO
}

- (void)failedReceivingRoute{
    //TODO
}

@end
