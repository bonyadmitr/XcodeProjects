//
//  ZZStudent.h
//  EditingCellsTest
//
//  Created by zdaecqze zdaecq on 28.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZStudent : NSObject

@property (strong,nonatomic) NSString* firstName;
@property (strong,nonatomic) NSString* lastName;
@property (assign, nonatomic) float averageGrade;

+(ZZStudent*) randomStudent;

@end
