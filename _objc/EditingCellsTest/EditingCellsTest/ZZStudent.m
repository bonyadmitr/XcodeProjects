//
//  ZZStudent.m
//  EditingCellsTest
//
//  Created by zdaecqze zdaecq on 28.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ZZStudent.h"

@implementation ZZStudent

// так объявлется С класс
//static NSString* firstNameArray[] ={
//    @"qwewqeqwe", @"dsfsdfsdf"
//};

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

+(ZZStudent*) randomStudent{
    ZZStudent* student = [[ZZStudent alloc] init];
    
    student.firstName = [self randomString];
    student.lastName = [self randomString];
    student.averageGrade = (float)(arc4random() % 301 + 200) / 100;
    
    return student;
}

#pragma mark - NSObject methods

- (NSString *)description
{
    return [NSString stringWithFormat:  @"\n"
                                        @"firstName: %@\n"
                                        @"lastName: %@\n"
                                        @"averageGrade: %1.2f",
                                        self.firstName, self.lastName, self.averageGrade];
}

@end
