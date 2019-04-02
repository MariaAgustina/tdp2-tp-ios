//
//  GMSMarker+Setup.h
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMSMarker (Setup)

- (void)setupWithPlace:(GMSPlace*)place andMapView:(GMSMapView*)mapView;

@end

NS_ASSUME_NONNULL_END
