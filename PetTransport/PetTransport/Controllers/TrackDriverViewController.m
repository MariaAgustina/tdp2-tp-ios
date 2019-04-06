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

@interface TrackDriverViewController () <TrackDriverServideDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *driverMarker;
@property (strong, nonatomic) GMSMarker *originMarker;
@property BOOL tracking;

@end

@implementation TrackDriverViewController

const float ANIMATION_TIME_SECONDS = 5.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Esperando al chofer";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.trip == nil){
        NSLog(@"------ NO TENGO TRIP ---------");
    }
    
    [self centerCamera:[self.trip getOriginCoordinate]];
    [self positionMarker:self.originMarker inCoordinate:[self.trip getOriginCoordinate]];
    self.tracking = false;
    [self trackDriver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TrackDriverService sharedInstance] stopTracking];
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

- (GMSMarker *)originMarker {
    if (_originMarker == nil) {
        _originMarker = [[GMSMarker alloc] init];
        _originMarker.title = @"Origen";
        _originMarker.map = self.mapView;
    }
    return _originMarker;
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

- (void)driverDidArrive {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"El chofer ya está esperandote"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK!"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
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
        [self driverDidArrive];
    }
}

- (void)didFailTracking {
    NSLog(@"Did fail tracking");
}


@end
