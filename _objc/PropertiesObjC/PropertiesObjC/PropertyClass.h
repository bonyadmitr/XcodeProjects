//
//  PropertyClass.h
//  PropertiesObjC
//
//  Created by zdaecqze zdaecq on 10.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyClass : NSObject {
    int someInt;
@public
    NSString * name;
}

@property (strong, nonatomic) NSString* nameProperty;

@end
