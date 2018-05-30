//
//  ASRobot.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPilot.h"


@interface ASRobot : NSObject

@property (strong, nonatomic) id <RWPilot> pilot;
@property (strong, nonatomic) NSMutableArray* bodyParts;
@property (strong, nonatomic) NSString* name;

@property (assign, nonatomic) CGRect frame;



+ (ASRobot*) robotWithPilot:(id <RWPilot>) pilot;

@end
