//
//  FinishTripService.m
//  PetTransport
//
//  Created by agustina markosich on 5/5/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "FinishTripService.h"
#import "ApiClient.h"

#import "ClientService.h"

@interface FinishTripService ()

@property (nonatomic, weak) id <FinishTripServiceDelegate> delegate;

@end

@implementation FinishTripService

- (instancetype)initWithDelegate:(id <FinishTripServiceDelegate>)delegate{
    self.delegate = delegate;
    return self;
}

-(void)finishTrip:(Trip*)trip{
    NSString *relativeUrlString =[NSString stringWithFormat:@"trips/%ld",(long)trip.tripId] ;
    
    ApiClient *apiClient = [ApiClient new];
    
    NSDictionary* body = @{@"status":@"Finalizado"};
    
    [apiClient putWithRelativeUrlString:relativeUrlString body:body token:[[ClientService sharedInstance] getToken] success:^(id _Nullable responseObject){
        NSLog(@"response = %@",responseObject);
        [self.delegate finishTripServiceSuccededWithResponse:responseObject];
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Fallo al actualizar el status del conductor");
    }];
}
@end
