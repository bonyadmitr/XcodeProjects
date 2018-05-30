//
//  Task+CoreDataProperties.h
//  CoreDataObjCTest
//
//  Created by zdaecqze zdaecq on 13.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *index;

@end

NS_ASSUME_NONNULL_END
