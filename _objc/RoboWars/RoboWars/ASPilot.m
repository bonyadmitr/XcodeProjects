//
//  ASPilot.m
//  RoboWars
//
//  Created by Oleksii Skutarenko on 21.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import "ASPilot.h"


@implementation ASPilot

- (void) restart {
    
}

- (CGPoint) fire {
    
    return CGPointZero;
}

- (NSString*) robotName {
    
    return self.name;
}

- (void) shotFrom:(id<RWPilot>) robot withCoordinate:(CGPoint) coordinate andResult:(RWShotResult) result {

}

- (NSString*) victoryPhrase {
    return nil;
}


- (NSString*) defeatPhrase {
    return nil;
}

@end
