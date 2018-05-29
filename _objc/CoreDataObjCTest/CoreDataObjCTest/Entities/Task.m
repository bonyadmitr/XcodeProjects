//
//  Task.m
//  CoreDataObjCTest
//
//  Created by zdaecqze zdaecq on 13.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "Task.h"
#import "CoreDataManager.h"

@implementation Task

- (instancetype)init
{
    NSEntityDescription *entityDescription = [[CoreDataManager sharedInstance] entityForName:@"Task"];
    self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:[[CoreDataManager sharedInstance] managedObjectContext]];
    return self;
}

@end
