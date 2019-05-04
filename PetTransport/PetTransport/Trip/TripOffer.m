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
    if(self = [super init]){
        NSString* statusString = [dictionary objectForKey:@"status"];
        self.status = [self statusForString:statusString];
    }
    
    return self;
}
@end
