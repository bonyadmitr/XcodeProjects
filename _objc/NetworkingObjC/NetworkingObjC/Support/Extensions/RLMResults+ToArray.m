//
//  RLMResults+ToArray.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 13.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "RLMResults+ToArray.h"

@implementation RLMResults (ToArray)

- (NSArray *)toArray; {
    NSMutableArray *array = [NSMutableArray new];
    for (RLMObject *object in self) {
        [array addObject:object];
    }
    return array;
}

@end
