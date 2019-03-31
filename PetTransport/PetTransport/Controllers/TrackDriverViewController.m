//
//  TrackDriverViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 3/31/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TrackDriverViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationManager.h"

@interface TrackDriverViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *driverMarker;
@property (strong, nonatomic) NSTimer *timer;

// TODO: remove
@property (strong, nonatomic) NSArray *coordinates;
@property NSInteger coordinatesIndex;

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

// TODO: remove
- (NSArray *)coordinates {
    if (_coordinates == nil) {
        _coordinates = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(-34.564749, -58.441392)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.565001, -58.441666)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.565319, -58.441910)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.565742, -58.442309)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.566170, -58.442698)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.566563, -58.443044)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.566139, -58.443492)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.565574, -58.443948)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.564988, -58.444478)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.564760, -58.444626)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.564484, -58.444132)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.564038, -58.443354)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.563665, -58.442683)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.564107, -58.441927)],
                        nil];
        _coordinatesIndex = 0;
    }
    if (_coordinatesIndex >= _coordinates.count){
        _coordinatesIndex = 0;
    }
    return _coordinates;
}

- (void)trackDriver {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:self
                                                selector:@selector(updateDriverLocation)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateDriverLocation {
    CGPoint point = [[self.coordinates objectAtIndex:self.coordinatesIndex] CGPointValue];
    NSLog(@"UPDATE DRIVER LOCATION: %f, %f", point.x, point.y);
    self.coordinatesIndex++;
    
    struct LocationCoordinate coordinate;
    coordinate.latitude = point.x;
    coordinate.longitude = point.y;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    [self positionMarker:coordinate];
    [CATransaction commit];
    [self moveCamera:coordinate];
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

@end
