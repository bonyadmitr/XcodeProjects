//
//  PropertyClass.m
//  PropertiesObjC
//
//  Created by zdaecqze zdaecq on 10.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "PropertyClass.h"
#import <Foundation/Foundation.h>

@interface PropertyClass() {
    NSString *privateNameProperty2;
}

@property (strong, nonatomic) NSString* privateNameProperty;
@property int qwe;

@end

@implementation PropertyClass {
    int privateInt;
}


-(void)print {
    someInt = 10;
    name = @"";
    privateInt = 100;
    _privateNameProperty = @"123123";
    self.privateNameProperty = @"fsfsdf";
    privateNameProperty2 = @"12331231";
    
}


@end
