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
#import "TripService.h"
#import "UIViewController+ShowAlerts.h"

@interface DriverRouteViewController () <LocationManagerDelegate, TripServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *tripButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong,nonatomic) LocationManager *locationManager;

@property (strong,nonatomic) GMSMarker* originMarker;
@property (strong,nonatomic) GMSMarker* destinyMarker;

@property (strong,nonatomic) TripService* routesService;

@end

@implementation DriverRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[LocationManager alloc] init];
    
    [self setupOriginAndDestinationMarkers];
    
    self.routesService = [[TripService alloc] initWithDelegate:self];
    
    [self showLoading];
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

- (IBAction)tripButtonPressed:(id)sender {
    
}

#pragma mark - LocationManagerDelegate
- (void)didFetchCurrentLocation: (struct LocationCoordinate)coordinate {
    [self centerCamera:coordinate];
}

- (void)didFailFetchingCurrentLocation {
    NSLog(@"no pudo traer la location");
}

#pragma mark - TripServiceDelegate
- (void)succededReceivingRoute:(WayPoints*)wayPoints{
    [self hideLoading];
    GMSMutablePath *path = [GMSMutablePath path];
    
    for(CLLocation* waypoint in wayPoints.points){
        [path addCoordinate:waypoint.coordinate];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 6.f;
    polyline.map = self.mapView;
    
}

- (void)tripServiceFailedWithError:(NSError*)error{
    [self hideLoading];
    [self showInternetConexionAlert];
}

@end
