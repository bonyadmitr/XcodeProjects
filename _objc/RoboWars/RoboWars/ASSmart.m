//
//  ASSmart.m
//  RoboWars
//
//  Created by Oleksii Skutarenko on 08.11.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import "ASSmart.h"
#import "ASTarget.h"

@interface ASSmart ()

@property (strong, nonatomic) NSMutableArray* targets;

@end

@implementation ASSmart


#pragma mark - Help Functions

- (NSArray*) arrayOfTargetsWithSize:(CGSize) size excludingRect:(CGRect) excludingRect inFieldWithSize:(CGSize) fieldSize {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i <= fieldSize.width - size.width; i++) {
        for (int j = 0; j <= fieldSize.height - size.height; j++) {
            
            CGRect rect = CGRectMake(i, j, size.width, size.height);
            
            if (!CGRectIntersectsRect(excludingRect, rect)) {
                
                ASTarget* target = [[ASTarget alloc] initWithRect:rect];
                
                [array addObject:target];
            }
        }
    }
    
    return array;
}

- (void) missAtCoordinate:(CGPoint) coordinate {
    
    for (int i = (int)[self.targets count] - 1; i >= 0; i--) {
        
        ASTarget* target = [self.targets objectAtIndex:i];
        
        if (CGRectContainsPoint(target.rect, coordinate)) {
            [self.targets removeObject:target];
        }
        
    }
    
}

- (void) hitAtCoordinate:(CGPoint) coordinate {
    
    NSString* hp = NSStringFromCGPoint(coordinate);
    
    CGRect destroyedRect = CGRectZero;
    
    for (int i = (int)[self.targets count] - 1; i >= 0; i--) {
        
        ASTarget* target = [self.targets objectAtIndex:i];
        
        if ([target.health containsObject:hp]) {
            [target.health removeObject:hp];
            
            if ([target.health count] == 0) {
                destroyedRect = target.rect;
                [self.targets removeObjectAtIndex:i];
            }
        }
    }
    
    if (!CGRectIsEmpty(destroyedRect)) {
        [self targetDestroyedAtRect:destroyedRect];
    }
}

- (void) targetDestroyedAtRect:(CGRect) rect {
    
    rect = CGRectInset(rect, -1, -1);
    
    CGRect fieldRect = CGRectZero;
    fieldRect.size = self.fieldSize;
    
    for (int i = CGRectGetMinX(rect); i < CGRectGetMaxX(rect); i++) {
        for (int j = CGRectGetMinY(rect); j < CGRectGetMaxY(rect); j++) {
            
            CGPoint p = CGPointMake(i, j);
            
            if (CGRectContainsPoint(fieldRect, p)) {
                [self missAtCoordinate:p];
            }
        }
    }
}

- (NSArray*) lessHealthTargets {
    
    if ([self.targets count] <= 1) {
        return self.targets;
    }
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.targets];
    
    [array sortUsingComparator:^NSComparisonResult(ASTarget* obj1, ASTarget* obj2) {
        if ([obj1.health count] < [obj2.health count]) {
            return NSOrderedAscending;
        } else if ([obj1.health count] > [obj2.health count]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray* resultArray = [NSMutableArray array];
    
    NSInteger minHealth = NSIntegerMax;
    
    for (ASTarget* target in array) {
        if ([target.health count] <= minHealth) {
            minHealth = [target.health count];
            [resultArray addObject:target];
        } else {
            break;
        }
    }
    
    return resultArray;
}

- (NSArray*) bestHitChanceCoordinatesFromTargets:(NSArray*) targets {
    
    if ([targets count] == 0) {
        return nil;
    } else if ([targets count] == 1) {
        ASTarget* target = [targets firstObject];
        return [target.health allObjects];
    }
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (ASTarget* target in targets) {
        
        NSArray* coords = [target.health allObjects];
        
        for (NSString* key in coords) {
            
            NSNumber* number = [dictionary objectForKey:key];
            
            if (!number) {
                number = [NSNumber numberWithInteger:1];
            } else {
                NSInteger current = [number integerValue];
                number = [NSNumber numberWithInteger:current + 1];
            }
            [dictionary setObject:number forKey:key];
        }
    }
    
    if ([dictionary count] == 0) {
        return nil;
    } else if ([dictionary count] == 1) {
        return [dictionary allKeys];
    }
    
    NSArray* sortedCoords = [dictionary keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray* resultArray = [NSMutableArray array];
    
    NSInteger maxNumber = 0;
    
    for (int i = [sortedCoords count] - 1; i >= 0; i--) {
        
        NSString* key = [sortedCoords objectAtIndex:i];
        NSNumber* number = [dictionary objectForKey:key];
        
        if ([number integerValue] >= maxNumber) {
            maxNumber = [number integerValue];
            [resultArray addObject:key];
        } else {
            break;
        }
        
    }
    
    return resultArray;
}

#pragma mark - RWPilot

- (void) restart {
    
    self.targets = [NSMutableArray array];
    
    CGRect selfArea = CGRectInset(self.robotRect, -1, -1);
    
    CGFloat minSize = MIN(CGRectGetWidth(self.robotRect), CGRectGetHeight(self.robotRect));
    CGFloat maxSize = MAX(CGRectGetWidth(self.robotRect), CGRectGetHeight(self.robotRect));
    
    NSArray* verticalTargets = [self arrayOfTargetsWithSize:CGSizeMake(minSize, maxSize)
                                              excludingRect:selfArea
                                            inFieldWithSize:self.fieldSize];
    
    NSArray* horizontalTargets = [self arrayOfTargetsWithSize:CGSizeMake(maxSize, minSize)
                                                excludingRect:selfArea
                                              inFieldWithSize:self.fieldSize];
    
    [self.targets addObjectsFromArray:verticalTargets];
    [self.targets addObjectsFromArray:horizontalTargets];
}

- (CGPoint) fire {
    
    NSArray* minHealthTargets = [self lessHealthTargets];
    
    NSArray* coordinatesToFire = [self bestHitChanceCoordinatesFromTargets:minHealthTargets];
    
    if ([coordinatesToFire count] == 0) {
        NSLog(@"Cannot shoot :(");
        return CGPointMake(-10, -10);
    }
    
    NSString* stringCoord = [coordinatesToFire firstObject];
    
    return CGPointFromString(stringCoord);
}

- (NSString*) robotName {
    
    return @"Smart";
}

- (void) shotFrom:(id<RWPilot>) robot withCoordinate:(CGPoint) coordinate andResult:(RWShotResult) result {

    if (result == RWShotResultMiss) {
        [self missAtCoordinate:coordinate];
    } else {
        [self hitAtCoordinate:coordinate];
    }
    
    
}

- (NSString*) victoryPhrase {
    return @"I am the winner!";
}


- (NSString*) defeatPhrase {
    return @"Goodbye guys!";
}


@end
