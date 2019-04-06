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
    
    if (!self.tripId){
        NSLog(@"------ NO TENGO TRIP ID ---------");
    }
    
    struct LocationCoordinate initialCameraCoordinate;
    initialCameraCoordinate.latitude = -34.564749;
    initialCameraCoordinate.longitude = -58.441392;
    [self centerCamera:initialCameraCoordinate];
    
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

- (void)trackDriver {
    TrackDriverService *service = [TrackDriverService sharedInstance];
    [service startTrackingDriverForTrip:self.tripId WithDelegate:self];
}

- (void)positionMarker: (struct LocationCoordinate) coordinate {
    self.driverMarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
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
    [self positionMarker:coordinate];
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
