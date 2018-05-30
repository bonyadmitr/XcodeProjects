//
//  AppDelegate.m
//  MRCtest
//
//  Created by Bondar Yaroslav on 10/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/// Enable MRC in all project
/// App>Targets>Build Settings> Search for "Automatic Reference Counting", set NO
/// https://stackoverflow.com/a/13899120/5893286

/// ARC management in some files
/// https://stackoverflow.com/a/21229878/5893286
/// enabled ARC App>Targets>Build Phases>Compile Sources> add flag after class
/// -fobjc-arc
/// to disable ARC and turn on MRC use flag
/// -fno-objc-arc

/// Need for MRC
//- (void)dealloc {
//    [_window release];
//    [super dealloc];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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
