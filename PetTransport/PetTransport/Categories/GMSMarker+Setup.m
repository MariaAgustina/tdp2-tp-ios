//
//  GMSMarker+Setup.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "GMSMarker+Setup.h"



@implementation GMSMarker (Setup)

- (void)setupWithPlace:(GMSPlace*)place andMapView:(GMSMapView*)mapView{
    self.map = nil; //To reset the market from the view
    self.position = place.coordinate;
    self.snippet = place.name;
    self.map = mapView;
}

-(void)setupWithCoordinate:(CLLocationCoordinate2D)coordinate address:(NSString*)address andMapView:(GMSMapView*)mapView{
    self.map = nil; //To reset the market from the view
    self.position = coordinate;
    self.snippet = address;
    self.map = mapView;
}

@end
