//
//  ZZDay.h
//  TimeTableDynamic
//
//  Created by zdaecqze zdaecq on 31.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface ZZDay : NSObject

@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSMutableArray* classesArray;
@property(strong,nonatomic) UIColor* headerColor;

@end
