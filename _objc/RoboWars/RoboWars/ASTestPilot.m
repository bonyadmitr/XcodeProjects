//
//  ASTestPilot.m
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import "ASTestPilot.h"


@interface ASTestPilot ()

@property (strong, nonatomic) NSMutableDictionary* shots;

@end


@implementation ASTestPilot

- (void) restart {
    self.shots = [NSMutableDictionary dictionary];
}

- (CGPoint) fire {
    
    
    BOOL availableCoordinate = NO;
    
    CGPoint coordinate = CGPointZero;
    
    while (!availableCoordinate) {
        
        coordinate = CGPointMake(arc4random() % (int)self.fieldSize.width, arc4random() % (int)self.fieldSize.height);
    
        availableCoordinate = !CGRectContainsPoint(self.robotRect, coordinate) && ![self.shots objectForKey:NSStringFromCGPoint(coordinate)];

    }
    
    return coordinate;
    
}

- (NSString*) robotName {
    
    static NSInteger number = 0;
    
    return [NSString stringWithFormat:@"%d", ++number];
}

- (void) shotFrom:(id<RWPilot>) robot withCoordinate:(CGPoint) coordinate andResult:(RWShotResult) result {
    
    if (!self.shots) {
        self.shots = [NSMutableDictionary dictionary];
    }
    
    [self.shots setObject:@"" forKey:NSStringFromCGPoint(coordinate)];
}

- (NSString*) victoryPhrase {
    return @"I am the winner!";
}


- (NSString*) defeatPhrase {
    return @"Goodbye guys!";
}

@end
