//
//  UIImage+Base64.m
//  PetTransport
//
//  Created by agustina markosich on 4/20/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "UIImage+Base64.h"

@implementation UIImage (Base64)

- (NSString*)getBase64
{
    NSData *imageData = UIImagePNGRepresentation(self);
    NSString * base64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64String;
}

@end
