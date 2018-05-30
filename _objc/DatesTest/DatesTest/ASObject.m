//
//  ASObject.m
//  DatesTest
//
//  Created by zdaecqze zdaecq on 15.12.15.
//  Copyright © 2015 zdaecqze zdaecq. All rights reserved.
//

#import "ASObject.h"

@implementation ASObject


-(void) testTimer
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hh:mm:ss:SSS"];
    NSLog(@"%@", [dateformatter stringFromDate:[NSDate new]]);
}

-(void) cancelTimer
{
    [self.timer invalidate];
}

#pragma mark - initialisation
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(testTimer) userInfo:0 repeats:YES];
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
    return self;
}

-(void) dealloc
{
    NSLog(@"ASObject dealocated");
}


@end
