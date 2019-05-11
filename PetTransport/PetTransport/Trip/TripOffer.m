//
//  TripOffer.m
//  PetTransport
//
//  Created by agustina markosich on 5/4/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "TripOffer.h"

NSString* const kAccepted = @"Aceptado";
NSString* const kRejected = @"Rechazado";
NSString* const kPending = @"Pendiente";
NSString* const kStatus = @"status";

@interface TripOffer ()

@property (strong,nonatomic) NSDictionary* tripOfferDictionary;

@end

@implementation TripOffer

- (NSString*)statusForType:(TripOfferStatusType)tripOfferStatusType {
    
    NSString* status;
    switch(tripOfferStatusType) {
        case ACCEPTED:
           status = kAccepted;
            break;
        case REJECTED:
            status = kRejected;
            break;
        case PENDING:
            status = kPending;
            break;
        default:
            status = kPending;
    }
    
    return status;
}

- (TripOfferStatusType)statusForString:(NSString*)status {
    
    if([status isEqualToString:kAccepted]){
        return ACCEPTED;
    }
    
    if ([status isEqualToString:kRejected]){
        return REJECTED;
    }
 
    return PENDING;
    
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    self.tripOfferDictionary = dictionary;
    
    NSString* statusString = [dictionary objectForKey:@"status"];
    self.status = [self statusForString:statusString];
    
    NSDictionary* originDictionary = [dictionary objectForKey:@"origin"];
    self.originAddress = [originDictionary objectForKey:@"address"];
    
    NSDictionary* destinationDictionary = [dictionary objectForKey:@"destination"];
    self.destinationAddress = [destinationDictionary objectForKey:@"address"];
    
    NSString *reservationDateString = [dictionary objectForKey:@"reservationDate"];
    if ((id)reservationDateString != [NSNull null]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        self.scheduleDate = [dateFormatter dateFromString:reservationDateString];
    }
    
    return self;
}

- (NSDictionary*)updateDictionaryForStatus:(TripOfferStatusType)status
{
    NSString* statusString = [self statusForType:status];
    NSMutableDictionary* tripOfferMutable = [self.tripOfferDictionary mutableCopy];
    [tripOfferMutable setValue:statusString forKey:kStatus];
    return [tripOfferMutable copy];
}

- (BOOL)isScheduled {
    return self.scheduleDate != nil;
}

@end
