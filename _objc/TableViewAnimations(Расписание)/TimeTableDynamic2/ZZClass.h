//
//  ZZClass.h
//  TimeTableDynamic
//
//  Created by zdaecqze zdaecq on 30.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZClass : NSObject

@property (strong, nonatomic) NSString* nameOfClass;
@property (strong, nonatomic) NSString* nameOfTeacher;

+(ZZClass*) randomClass;

@end
