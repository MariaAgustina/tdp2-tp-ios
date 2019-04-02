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
                                                                 zoom:17];
    [self.mapView setCamera:camera];
}

- (void)moveCamera: (struct LocationCoordinate) coordinate {
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
}

#pragma mark - TrackDriverServiceDelegate

- (void)didUpdateDriverLocation: (struct LocationCoordinate)coordinate andStatus:(DriverStatus)status {
    NSLog(@"Status: %i", (int)status);
    if (status == DRIVER_STATUS_GOING){
        NSLog(@"VIAJANDOOOOO");
    } else {
        NSLog(@"ya LLEGUE");
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    [self positionMarker:coordinate];
    [CATransaction commit];
    [self moveCamera:coordinate];
}

- (void)didFailTracking {
    NSLog(@"Did fail tracking");
}


@end
