//
//  BookTransportViewController.m
//  PetTransport
//
//  Created by Kaoru Heanna on 3/30/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "BookTransportViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationManager.h"

@interface BookTransportViewController ()

@end

@implementation BookTransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Estoy en Book Transport");
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [self fetchCurrentLocation];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-34.635487
                                                            longitude:-58.364654
                                                                 zoom:17];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-34.635487, -58.364654);
    marker.title = @"Aca estoy";
    marker.map = mapView;
}

- (void)fetchCurrentLocation {
    [[LocationManager sharedInstance] fetchCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
