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
        // HACK porque viene mal la hora de la api
        self.scheduleDate = [date dateByAddingTimeInterval:3 * 3600];
    }
    
    self.cost = [dictionary objectForKey:@"cost"];
    
    NSDictionary *petQuantities = [dictionary objectForKey:@"petQuantities"];
    self.smallPetsQuantity = [[petQuantities objectForKey:@"small"] integerValue];
    self.mediumPetsQuantity = [[petQuantities objectForKey:@"medium"] integerValue];
    self.bigPetsQuantity = [[petQuantities objectForKey:@"big"] integerValue];
    self.bringsEscort = [[dictionary objectForKey:@"bringsEscort"] boolValue];
    self.comments = [dictionary objectForKey:@"comments"];
    self.clientName = [[dictionary objectForKey:@"client"] objectForKey:@"name"];
    
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

@end
