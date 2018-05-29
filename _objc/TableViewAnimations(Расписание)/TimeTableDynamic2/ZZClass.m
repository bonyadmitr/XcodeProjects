//
//  ZZClass.m
//  TimeTableDynamic
//
//  Created by zdaecqze zdaecq on 30.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ZZClass.h"

@implementation ZZClass

#pragma mark - Local Methods

+(NSString*) randomString{
    
    int stringLength = arc4random() % 7 + 3;
    char str[stringLength];
    str[stringLength] = 0; // т.к. не всегда выделяет пустую строку
    
    //'A' = 65
    //'a' = 97
    
    str[0] = arc4random() % 26 + 65;
    for (int i = 1; i < stringLength; i++) {
        str[i] = arc4random() % 26 + 97;
    }
    
    return [NSString stringWithFormat:@"%s", str];
}

#pragma mark - Class Methods

+(ZZClass*) randomClass{
    ZZClass* class = [[ZZClass alloc] init];
    
    class.nameOfClass = [ZZClass randomString];
    class.nameOfTeacher = [self randomString];
    
    return class;
}

@end
