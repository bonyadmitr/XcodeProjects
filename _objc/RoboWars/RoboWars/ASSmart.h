//
//  ASSmart.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 08.11.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPilot.h"

@interface ASSmart : NSObject <RWPilot>

@property (assign, nonatomic) CGRect robotRect;
@property (assign, nonatomic) CGSize fieldSize;

@end
