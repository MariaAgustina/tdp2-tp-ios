//
//  Trip.m
//  PetTransport
//
//  Created by agustina markosich on 4/2/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "Trip.h"

NSString* const kAcceptedStatusKey = @"Aceptado";
NSString* const kRejectedStatusKey = @"Rechazado";
NSString* const kPendingStatusKey = @"Pendiente";
NSString* const kSearchingStatusKey = @"Buscando";

typedef enum TripStatusTypes {
    ACCEPTED,
    REJECTED,
    PENDING,
    SEARCHING
} TripStatus;

@interface Trip ()

@property (nonatomic) TripStatus status;

@end

@implementation Trip

- (instancetype)initWithDictionary: (NSDictionary*)dictionary {
    self = [super init];
    
    self.tripId = [[dictionary objectForKey:@"id"] integerValue];
    
    NSString* statusString = [dictionary objectForKey:@"status"];
    self.status = [self statusForString:statusString];
    
    NSDictionary* originDictionary = [dictionary objectForKey:@"origin"];
    self.origin = [[PTLocation alloc] initWithDictionary:originDictionary];
    
    NSDictionary* destinationDictionary = [dictionary objectForKey:@"destination"];
    self.destination = [[PTLocation alloc] initWithDictionary:destinationDictionary];
    
    NSString *reservationDateString = [dictionary objectForKey:@"reservationDate"];
    if ((id)reservationDateString != [NSNull null]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        self.scheduleDate = [dateFormatter dateFromString:reservationDateString];
    }
    
    return self;
}

- (struct LocationCoordinate)getOriginCoordinate {
    return self.origin.coordinate;
}

- (TripStatus)statusForString:(NSString*)status {
    if([status isEqualToString:kAcceptedStatusKey]){
        return ACCEPTED;
    }
    if ([status isEqualToString:kRejectedStatusKey]){
        return REJECTED;
    }
    if ([status isEqualToString:kSearchingStatusKey]){
        return SEARCHING;
    }
    return PENDING;
}

- (BOOL)isScheduled {
    return self.scheduleDate != nil;
}

- (BOOL)isAccepted {
    return self.status == ACCEPTED;
}

- (BOOL)isPending {
    return self.status == PENDING;
}

- (BOOL)isRejected {
    return self.status == REJECTED;
}

- (void)accept {
    self.status = ACCEPTED;
}

- (void)reject {
    self.status = REJECTED;
}

@end
