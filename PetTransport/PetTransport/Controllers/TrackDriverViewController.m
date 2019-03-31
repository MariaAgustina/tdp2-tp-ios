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
        _driverMarker.map = self.mapView;
    }
    return _driverMarker;
}

// TODO: remove
- (NSArray *)coordinates {
    if (_coordinates == nil) {
        _coordinates = [NSArray arrayWithObjects:
                        [NSValue valueWithCGPoint:CGPointMake(-34.564389, -58.454457)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.563470, -58.455380)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.562569, -58.456338)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.560453, -58.458920)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.562926, -58.462853)],
                        [NSValue valueWithCGPoint:CGPointMake(-34.560466, -58.470583)],
                        nil];
        _coordinatesIndex = 0;
    }
    if (_coordinatesIndex >= _coordinates.count){
        _coordinatesIndex = 0;
    }
    return _coordinates;
}

- (void)trackDriver {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
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
    [self centerCamera:coordinate];
    [CATransaction commit];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
