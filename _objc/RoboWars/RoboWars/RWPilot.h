//
//  RWPilot.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
    RWShotResultMiss,
    RWShotResultHit,
    RWShotResultDestroy
    
} RWShotResult;


@protocol RWPilot <NSObject>

@required

@property (assign, nonatomic, readwrite) CGRect robotRect;
@property (assign, nonatomic, readwrite) CGSize fieldSize;

- (NSString*) robotName;

- (CGPoint) fire;

- (void) shotFrom:(id<RWPilot>) robot withCoordinate:(CGPoint) coordinate andResult:(RWShotResult) result;

- (void) restart;

@optional

- (NSString*) victoryPhrase;
- (NSString*) defeatPhrase;

@end
