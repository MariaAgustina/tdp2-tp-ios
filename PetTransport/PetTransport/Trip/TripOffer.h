//
//  TripOffer.h
//  PetTransport
//
//  Created by agustina markosich on 5/4/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripOffer : Trip

typedef enum TripOfferStatus
{
    ACCEPTED,
    REJECTED,
    PENDING
} TripOfferStatusType;

@property (nonatomic) TripOfferStatusType status;

- (NSString*)statusForType:(TripOfferStatusType)tripOfferStatusType;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)updateDictionaryForStatus:(TripOfferStatusType)status;
- (BOOL)isScheduled;
- (BOOL)isPending;
- (BOOL)isAccepted;
- (BOOL)isRejected;

@property (copy,nonatomic) NSString* originAddress;
@property (copy,nonatomic) NSString* destinationAddress;


@end

NS_ASSUME_NONNULL_END
