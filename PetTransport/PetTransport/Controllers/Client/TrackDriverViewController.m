//
//  TrackDriverViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 3/31/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TrackDriverViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationCoordinate.h"
#import "TrackDriverService.h"
#import "UIViewController+ShowAlerts.h"
#import "FinishTripService.h"
#import "RateServiceViewController.h"
#import "TripService.h"
#import "GMSMarker+Setup.h"
#import <GooglePlaces/GooglePlaces.h>
#import "CoordinateAddapter.h"

@interface TrackDriverViewController () <TrackDriverServideDelegate, FinishTripServiceDelegate, TripServiceDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) GMSMarker *driverMarker;
@property (strong, nonatomic) GMSMarker *originMarker;
@property (strong, nonatomic) GMSMarker *destinationMarker;

@property BOOL tracking;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) FinishTripService *finishTripService;
@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong,nonatomic) TripService* tripService;


@end

@implementation TrackDriverViewController

const float ANIMATION_TIME_SECONDS = 5.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Seguimiento";
    self.finishTripService = [[FinishTripService alloc]initWithDelegate:self];
    self.tripService = [[TripService alloc] initWithDelegate:self];

    [self.tripService retrieveTripWithId:self.trip.tripId];
    [self.tripService getTripCoordinates:self.trip];

}

- (void)setupOriginAndDestinationMarkers
{
    self.originMarker = [GMSMarker new];
    self.originMarker.title = @"Origen";
    CLLocationCoordinate2D origin = [CoordinateAddapter getCoordinate:self.trip.origin.coordinate];
    [self.originMarker setupWithCoordinate:origin address:self.trip.origin.address andMapView:self.mapView];
    
    self.destinationMarker = [GMSMarker new];
    self.destinationMarker.title = @"Destino";
    self.destinationMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    CLLocationCoordinate2D destination = [CoordinateAddapter getCoordinate:self.trip.destination.coordinate];
    [self.destinationMarker setupWithCoordinate:destination address:self.trip.destination.address andMapView:self.mapView];
}


- (void)endTrip{
    [self.finishTripService finishTrip:self.trip];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.trip == nil){
        NSLog(@"------ NO TENGO TRIP ---------");
    }
    [self.statusLabel setText:@""];
    [self centerCamera:[self.trip getOriginCoordinate]];
    [self setupOriginAndDestinationMarkers];
    self.tracking = false;
    [self trackDriver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TrackDriverService sharedInstance] stopTracking];
    [self.timer invalidate];
    self.timer = nil;
}

- (GMSMarker *)driverMarker {
    if (_driverMarker == nil) {
        _driverMarker = [[GMSMarker alloc] init];
        _driverMarker.title = @"Chofer";
        _driverMarker.icon = [UIImage imageNamed:@"car-icon"];
        _driverMarker.map = self.mapView;
    }
    return _driverMarker;
}

- (void)trackDriver {
    TrackDriverService *service = [TrackDriverService sharedInstance];
    [service startTrackingDriverForTrip:self.trip.tripId WithDelegate:self];
}

- (void)positionMarker:(GMSMarker*)marker inCoordinate:(struct LocationCoordinate) coordinate {
    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
}

- (void)centerCamera: (struct LocationCoordinate) coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:16];
    [self.mapView setCamera:camera];
}

- (void)moveCamera: (struct LocationCoordinate) coordinate {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: ANIMATION_TIME_SECONDS] forKey:kCATransactionAnimationDuration];
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
    [CATransaction commit];
}

#pragma mark - TrackDriverServiceDelegate

- (void)didUpdateDriverLocation: (struct LocationCoordinate)coordinate andStatus:(DriverStatus)status {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:ANIMATION_TIME_SECONDS];
    [self positionMarker:self.driverMarker inCoordinate:coordinate];
    [CATransaction commit];
    
    if (self.tracking){
        [self moveCamera:coordinate];
    } else {
        [self centerCamera:coordinate];
    }
    self.tracking = true;
    
    if (status == DRIVER_STATUS_IN_ORIGIN){
        [self.statusLabel setText:@"Estado actual: En origen"];
    } else if (status == DRIVER_STATUS_GOING) {
        [self.statusLabel setText:@"Estado actual: En camino"];
    }else if (status == DRIVER_STATUS_SEARCHING){
        //esto no deberia pasar nunca
        [self.statusLabel setText:@"Estado actual: Buscando conductor"];
    }else if (status == DRIVER_STATUS_ON_TRIP){
        [self.statusLabel setText:@"Estado actual: En viaje"];
    }else if (status == DRIVER_STATUS_ARRIVED){
        [self.statusLabel setText:@"Estado actual: Llegamos"];
    }else if (status == DRIVER_STATUS_FINISHED){
        [self.statusLabel setText:@"Estado actual: Finalizado"];
        [self endTrip];
    }
}

- (void)didFailTracking {
    [self showInternetConexionAlert];
}

#pragma mark - FinishTripService

- (void)finishTripServiceSuccededWithResponse:(NSDictionary*)response{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RateServiceViewController *rateServiceViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"RateServiceViewController"];
    rateServiceViewController.trip = self.trip;
    [self.navigationController pushViewController:rateServiceViewController animated:YES];
}

- (void)finishTripServiceFailedWithError:(NSError*)error{
    
}

#pragma mark - TripServiceDelegate

- (void)didReturnTrip:(Trip*)trip{
    self.trip = trip;
    if(trip.driverName){
        self.driverLabel.text = [NSString stringWithFormat:@"Chofer: %@",trip.driverName];
    }
    if(trip.driverPhone){
        self.phoneLabel.text = [NSString stringWithFormat:@"Teléfono: %@",trip.driverPhone];
    }
    if(trip.cost){
        self.priceLabel.text = [NSString stringWithFormat:@"$ %@",trip.cost];
    }
}

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
@end
