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
NSString* const kReservedStatusKey = @"Reservado";
NSString* const kCancelledStatusKey = @"Cancelado";
NSString* const kGoingToPickupStatusKey = @"En camino";
NSString* const kInOriginStatusKey = @"En origen";
NSString* const kTravellingStatusKey = @"En viaje";
NSString* const kInDestinatioStatusKey = @"Llegamos";
NSString* const kFinishedStatusKey = @"Finalizado";

@interface Trip ()

@property (nonatomic) NSString *status;
@property (strong, nonatomic) NSDictionary *originalDict;

@end

@implementation Trip

- (instancetype)initWithDictionary: (NSDictionary*)dictionary {
    self = [super init];
    self.originalDict = [dictionary copy];
    
    self.tripId = [[dictionary objectForKey:@"id"] integerValue];
    
    self.status = [dictionary objectForKey:@"status"];
    
    NSDictionary* originDictionary = [dictionary objectForKey:@"origin"];
    self.origin = [[PTLocation alloc] initWithDictionary:originDictionary];
    
    NSDictionary* destinationDictionary = [dictionary objectForKey:@"destination"];
    self.destination = [[PTLocation alloc] initWithDictionary:destinationDictionary];
    
    NSString *reservationDateString = [dictionary objectForKey:@"reservationDate"];
    if ((id)reservationDateString != [NSNull null]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
        NSDate *date = [dateFormatter dateFromString:reservationDateString];
        self.scheduleDate = date;
    }
    
    NSNumber *cost = [dictionary objectForKey:@"cost"];
    self.cost = [cost stringValue];
    
    NSDictionary *petQuantities = [dictionary objectForKey:@"petQuantities"];
    self.smallPetsQuantity = [[petQuantities objectForKey:@"small"] integerValue];
    self.mediumPetsQuantity = [[petQuantities objectForKey:@"medium"] integerValue];
    self.bigPetsQuantity = [[petQuantities objectForKey:@"big"] integerValue];
    self.bringsEscort = [[dictionary objectForKey:@"bringsEscort"] boolValue];
    self.comments = [dictionary objectForKey:@"comments"];
    self.clientName = [[dictionary objectForKey:@"client"] objectForKey:@"name"];
    self.clientId = [[dictionary objectForKey:@"clientId"] integerValue];
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary *attrs = [self.originalDict mutableCopy];
    [attrs setObject:self.status forKey:@"status"];
    
    return attrs;
}

- (struct LocationCoordinate)getOriginCoordinate {
    return self.origin.coordinate;
}

- (BOOL)isScheduled {
    return self.scheduleDate != nil;
}

- (NSString*) getStatusName {
    if ([self isGoingToPickup]){
        return @"En Camino";
    }
    if ([self isAtOrigin]){
        return @"En Origen";
    }
    if ([self isTravelling]){
        return @"En Viaje";
    }
    if ([self isAtDestination]){
        return @"Llegamos";
    }
    if ([self isFinished]){
        return @"Finalizado";
    }
    return @"";
}

- (BOOL)isAccepted {
    return [self.status isEqualToString:kAcceptedStatusKey];
}

- (BOOL)isPending {
    return [self.status isEqualToString:kPendingStatusKey];
}

- (BOOL)isRejected {
    return [self.status isEqualToString:kRejectedStatusKey];
}

- (void)accept {
    self.status = [kAcceptedStatusKey copy];
}

- (void)reject {
    self.status = [kRejectedStatusKey copy];
}

- (BOOL)isGoingToPickup {
    // HACK
    if ([self.status isEqualToString:kSearchingStatusKey] || [self.status isEqualToString:kAcceptedStatusKey]){
        return YES;
    }
    
    return [self.status isEqualToString:kGoingToPickupStatusKey];
}

- (BOOL)isAtOrigin {
    return [self.status isEqualToString:kInOriginStatusKey];
}

- (BOOL)isTravelling {
    return [self.status isEqualToString:kTravellingStatusKey];
}

- (BOOL)isAtDestination {
    return [self.status isEqualToString:kInDestinatioStatusKey];
}

- (BOOL)isFinished {
    return [self.status isEqualToString:kFinishedStatusKey];
}

@end
