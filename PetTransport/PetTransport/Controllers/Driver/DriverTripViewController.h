//
//  DriverTripViewController.h
//  PetTransport
//
//  Created by Kaoru Heanna on 5/12/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriverTripViewController : UIViewController

@property NSInteger tripId;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@end
