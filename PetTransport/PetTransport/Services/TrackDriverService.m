//
//  TrackDriverService.m
//  PetTransport
//
//  Created by Kaoru Heanna on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TrackDriverService.h"
#import <UIKit/UIKit.h>

@interface TrackDriverService ()

@property (nonatomic, weak) id<TrackDriverServideDelegate> delegate;
@property (strong, nonatomic) NSTimer *timer;

// TODO: remove
@property (strong, nonatomic) NSArray *coordinates;
@property NSInteger coordinatesIndex;

@end

@implementation TrackDriverService

+ (instancetype)sharedInstance {
    static TrackDriverService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TrackDriverService alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    return self;
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
    }
    return _coordinates;
}

- (void)startTrackingDriverWithDelegate:(id<TrackDriverServideDelegate>)delegate {
    self.coordinatesIndex = 0;
    
    self.delegate = delegate;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:self
                                                selector:@selector(updateDriverLocation)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateDriverLocation {
    if (self.delegate == nil){
        [self stopTracking];
    }
    
    CGPoint point = [[self.coordinates objectAtIndex:self.coordinatesIndex] CGPointValue];
    self.coordinatesIndex++;
    
    struct LocationCoordinate coordinate;
    coordinate.latitude = point.x;
    coordinate.longitude = point.y;
    
    BOOL didArrive = (self.coordinatesIndex >= self.coordinates.count);
    DriverStatus status = didArrive ? DRIVER_STATUS_IN_ORIGIN : DRIVER_STATUS_GOING;
    [self.delegate didUpdateDriverLocation:coordinate andStatus:status];

    if (didArrive) {
        [self stopTracking];
    }
}

- (void)stopTracking {
    [self.timer invalidate];
    self.timer = nil;
    self.delegate = nil;
}

@end
