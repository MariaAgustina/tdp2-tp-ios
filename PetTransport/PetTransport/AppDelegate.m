//
//  AppDelegate.m
//  PetTransport
//
//  Created by agustina markosich on 3/24/19.
//  Copyright © 2019 agustina markosich. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
@import GooglePlaces;
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define GMAPS_API_KEY @"AIzaSyBHopQabuqy_MPF6b0Pse8vEtwmXbL8r58"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initialVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:initialVC];
    
    navController.navigationBar.topItem.title = @"";
    navController.navigationBar.barStyle = UIBarStyleDefault;
    navController.navigationBar.barTintColor = [UIColor colorWithRed:38.0/255.0 green:166.0/255.0 blue:154.0/255.0 alpha:1.0];
    navController.navigationBar.translucent = NO;
    navController.navigationBar.opaque = YES;
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    
    [GMSServices provideAPIKey:GMAPS_API_KEY ];
    [GMSPlacesClient provideAPIKey:GMAPS_API_KEY];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
