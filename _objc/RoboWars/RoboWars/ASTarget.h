//
//  ASTarget.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 08.11.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASTarget : NSObject

@property (assign, nonatomic) CGRect rect;
@property (strong, nonatomic) NSMutableSet* health;

- (id) initWithRect:(CGRect) rect;

@end
