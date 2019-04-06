//
//  UIViewController+ShowAlerts.m
//  PetTransport
//
//  Created by agustina markosich on 4/6/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "UIViewController+ShowAlerts.h"

@implementation UIViewController (ShowAlerts)

- (void)showInternetConexionAlert{    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"¡Lo sentimos! Hubo un error de conexión, intenta denuevo más tarde." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
