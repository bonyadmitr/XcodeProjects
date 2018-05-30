//
//  CoreDataManager.h
//  CoreDataObjCTest
//
//  Created by zdaecqze zdaecq on 13.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSEntityDescription *)entityForName:(NSString *)entityName;
- (NSFetchedResultsController *)fetchedResultsControllerForEnity: (NSString *)entityName keyForSort: (NSString *) keyForSort ascending:(BOOL) ascending;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
