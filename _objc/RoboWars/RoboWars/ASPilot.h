//
//  ASPilot.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 21.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWPilot.h"

@interface ASPilot : NSObject <RWPilot>

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CGRect robotRect;
@property (assign, nonatomic) CGSize fieldSize;

@end
