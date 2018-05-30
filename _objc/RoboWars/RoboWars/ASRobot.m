//
//  ASRobot.m
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import "ASRobot.h"

@implementation ASRobot

+ (ASRobot*) robotWithPilot:(id <RWPilot>) pilot {
    ASRobot* robot = [[ASRobot alloc] init];
    robot.pilot = pilot;
    robot.bodyParts = [NSMutableArray array];
    robot.name = [pilot robotName];
    robot.frame = pilot.robotRect;
    return robot;
}

- (void) setFrame:(CGRect)frame {
    _frame = frame;
    self.pilot.robotRect = frame;
}

@end
