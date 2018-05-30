//
//  AppDelegate.m
//  DatesTest
//
//  Created by zdaecqze zdaecq on 15.12.15.
//  Copyright © 2015 zdaecqze zdaecq. All rights reserved.
//

#import "AppDelegate.h"
#import "ASObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDate* date = [NSDate date];
    /*
    NSLog(@"Date now: %@", date);
    date = [date dateByAddingTimeInterval:3600];
    NSLog(@"Date + 1h: %@", date);
    NSLog(@"Date + 2h: %@", [NSDate dateWithTimeInterval:3600 sinceDate:date]);
    */
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    
    /*
    [dateFormater setDateStyle:NSDateFormatterShortStyle];
    NSLog(@"%@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateStyle:NSDateFormatterNoStyle];
    NSLog(@"%@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateStyle:NSDateFormatterMediumStyle];
    NSLog(@"%@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateStyle:NSDateFormatterLongStyle];
    NSLog(@"%@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateStyle:NSDateFormatterFullStyle];
    NSLog(@"%@", [dateFormater stringFromDate:date]);
    */
    
    /*
    [dateFormater setDateFormat:@"y yy yyy yyyy yyyy"];
    NSLog(@"year: %@", [dateFormater stringFromDate:date]);

    [dateFormater setDateFormat:@"M MM MMM MMMM MMMMM"];
    NSLog(@"month: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"d dd ddd dddd ddddd"];
    NSLog(@"day: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"D DD DDD DDDD DDDDD"];
    NSLog(@"day in year: %@", [dateFormater stringFromDate:date]);

    [dateFormater setDateFormat:@"m mm mmm mmmm mmmmm"];
    NSLog(@"minutes: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"h hh hhh hhhh hhhhh"];
    NSLog(@"american hours: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"H HH HHH HHHH HHHHH"];
    NSLog(@"norm hours: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"s ss sss ssss sssss"];
    NSLog(@"seconds: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"S SS SSS SSSS SSSSS"];
    NSLog(@"MILIseconds: %@", [dateFormater stringFromDate:date]);

    [dateFormater setDateFormat:@"a"];
    NSLog(@"am/pm: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"E EE EEE EEEE EEEEE"];
    NSLog(@"day of week: %@", [dateFormater stringFromDate:date]);

    [dateFormater setDateFormat:@"w ww www wwww wwwww"];
    NSLog(@"week of year: %@", [dateFormater stringFromDate:date]);
    
    [dateFormater setDateFormat:@"W WW WWW WWWW WWWWW"];
    NSLog(@"week of month: %@", [dateFormater stringFromDate:date]);
     
     [dateFormater setDateFormat:@"d MMMM y 'at' H:m:s"];
     NSLog(@"Norm date: %@", [dateFormater stringFromDate:date]);
    */
    
    [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSLog(@"Norm date: %@", [dateFormater stringFromDate:date]);
    
    //[dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate* date2 = [dateFormater dateFromString:@"10/10/2010 10:10"];
    NSLog(@"%@", date2);
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* compnents = [calender components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                            fromDate:date2
                                            toDate:date options:0];
    NSLog(@"%@", compnents);
    
    
    ASObject* object = [ASObject new];
    //[object cancelTimer];
    // если не будет уничтожения таймера то объект не уничтожится
    [object performSelector:@selector(cancelTimer) withObject:nil afterDelay:5];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
