//
//  ASTestPilot.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPilot.h"

@interface ASTestPilot : NSObject <RWPilot>

@property (assign, nonatomic) CGRect robotRect;
@property (assign, nonatomic) CGSize fieldSize;

@end
