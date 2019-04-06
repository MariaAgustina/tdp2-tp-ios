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

@end

@implementation TrackDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    struct LocationCoordinate initialCameraCoordinate;
    initialCameraCoordinate.latitude = -34.564749;
    initialCameraCoordinate.longitude = -58.441392;
    [self centerCamera:initialCameraCoordinate];
    
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
    [service startTrackingDriverWithDelegate:self];
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
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
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
    NSLog(@"DID UPDATE DRIVER LOCATION: (%f, %f) ---> %ld", coordinate.latitude, coordinate.longitude, status);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.0];
    [self positionMarker:coordinate];
    [CATransaction commit];
    [self moveCamera:coordinate];
    
    if (status == DRIVER_STATUS_IN_ORIGIN){
        [self driverDidArrive];
    }
}

- (void)didFailTracking {
    NSLog(@"Did fail tracking");
}


@end
