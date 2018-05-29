//
//  TableViewController.m
//  CoreDataObjCTest
//
//  Created by zdaecqze zdaecq on 13.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "TableViewController.h"
#import "CoreDataManager.h"
#import "Task.h"

@interface TableViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation TableViewController {
    NSFetchedResultsController *fetchedResultsController;
}

#pragma mark - Lifeycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFetchedResultsController];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 44;
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - Setup

- (void)setupFetchedResultsController {
    fetchedResultsController = [[CoreDataManager sharedInstance] fetchedResultsControllerForEnity:@"Task"
                                                                                       keyForSort:@"index"
                                                                                        ascending:YES];
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:nil];
}

#pragma mark - Actions



#pragma mark - Navigation

- (IBAction)moveToTableViewController:(UIStoryboardSegue *)sender {}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Task *task = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", task.index];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSLog(@"sourse %ld", (long)sourceIndexPath.row);
    NSLog(@"dest %ld", (long)destinationIndexPath.row);
    
    UITableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
    NSLog(@"cell dest %@", cell3.detailTextLabel.text);

    UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:destinationIndexPath];
    NSLog(@"cell dest %@", cell2.detailTextLabel.text);
    
    int min;
    int max;
    if (sourceIndexPath.row > destinationIndexPath.row) {
        min = destinationIndexPath.row;
        max = sourceIndexPath.row;
        
    } else {
        min = sourceIndexPath.row + 1;
        max = destinationIndexPath.row + 1;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", destinationIndexPath.row + 1];
    
    NSLog(@"min %d", min);
    NSLog(@"max %d\n\n", max);
    
    for (; min < max; min++) {
//        Task *task = [fetchedResultsController.sections[fromIndexPath.section] objects][min];
//        task.index = [NSNumber numberWithInt:max - min + 1];
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:min inSection:sourceIndexPath.section];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
        
        if (sourceIndexPath.row > destinationIndexPath.row) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", min + 2];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", min];
        }
        
    }
    [[CoreDataManager sharedInstance] saveContext];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *task = [fetchedResultsController objectAtIndexPath:indexPath];
        [[[CoreDataManager sharedInstance] managedObjectContext] deleteObject:task];
        [[CoreDataManager sharedInstance] saveContext];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            
            NSIndexPath *zeroIndexPath = [NSIndexPath indexPathForRow:0 inSection:newIndexPath.section];
            [self.tableView insertRowsAtIndexPaths:@[zeroIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            for (int i = 0, n = [controller.sections[newIndexPath.section] numberOfObjects];  i < n; i++) {
                Task *task = [controller.sections[newIndexPath.section] objects][i];
                task.index = [NSNumber numberWithInt:i + 1];
                
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:newIndexPath.section];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", i + 2];
            }
            [[CoreDataManager sharedInstance] saveContext];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            for (int i = indexPath.row, n = [controller.sections[indexPath.section] numberOfObjects];  i < n; i++) {
                Task *task = [controller.sections[indexPath.section] objects][i];
                task.index = [NSNumber numberWithInt:i + 1];
                
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i + 1 inSection:indexPath.section];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellIndexPath];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", task.index];
            }
            [[CoreDataManager sharedInstance] saveContext];
            
            break;
        }
        case NSFetchedResultsChangeMove: {

            break;
        }
        case NSFetchedResultsChangeUpdate: {
            
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
