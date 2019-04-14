//
//  ClientProfile.h
//  PetTransport
//
//  Created by Kaoru Heanna on 4/14/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientProfile : NSObject

@property (strong, nonatomic) NSString *fbUserId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSDate *birthdate;
@property (strong, nonatomic) NSString *email;

@end
