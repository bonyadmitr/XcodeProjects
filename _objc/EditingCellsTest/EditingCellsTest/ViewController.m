//
//  ViewController.m
//  EditingCellsTest
//
//  Created by zdaecqze zdaecq on 28.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"
#import "ZZStudent.h"
#import "ZZStudentGroup.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* groupsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupsArray = [NSMutableArray array];
    
    /*
    NSInteger randNumberOfGroups = arc4random() % 5 + 3;
    NSInteger randNumberOfStudentsInGroup;
    
    for (int i = 0; i < randNumberOfGroups;  i++) {
        
        randNumberOfStudentsInGroup = arc4random() % 15 + 10;
        
        NSMutableArray* tempStudentsArray = [NSMutableArray array];
        for (int j = 0; j < randNumberOfStudentsInGroup; j++) {
            [tempStudentsArray addObject:[ZZStudent randomStudent]];
        }
        
        ZZStudentGroup* studentGroup = [[ZZStudentGroup alloc] init];
        studentGroup.name = [NSString stringWithFormat:@"Group %d", i+1];
        studentGroup.students = (NSArray*)tempStudentsArray;
        
        [self.groupsArray addObject:studentGroup];

    }
    
    [self.tableView reloadData];
    */
    
    self.tableView.allowsSelectionDuringEditing = NO;
    
    self.navigationItem.title = @"Students";
    
    UIBarButtonItem* barButtonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                   target:self
                                                                                   action:@selector(actionEdit:)];
    self.navigationItem.leftBarButtonItem = barButtonEdit;
    
    UIBarButtonItem* barButtonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(actionAddSection:)];
    self.navigationItem.rightBarButtonItem = barButtonAdd;

    
}

#pragma mark - Actions methods

-(void) actionEdit:(UIBarButtonItem*)sender{
    
    //BOOL isEditing = self.tableView.editing;
    //[self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem barButtonStyle;
    
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES animated:YES]; //self.tableView.editing = YES;
        barButtonStyle = UIBarButtonSystemItemDone;
    } else {
        [self.tableView setEditing:NO animated:YES];
        barButtonStyle = UIBarButtonSystemItemEdit;
    }
    
    UIBarButtonItem* newBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonStyle
                                                                                   target:self
                                                                                   action:@selector(actionEdit:)];
    [self.navigationItem setLeftBarButtonItem:newBarButton animated:YES];
    
}

-(void) actionAddSection:(UIBarButtonItem*)sender{
    
    ZZStudentGroup* newStudentGroup = [[ZZStudentGroup alloc] init];
    newStudentGroup.name = [NSString stringWithFormat:@"Group %d", [self.groupsArray count]+1];
    newStudentGroup.students = @[[ZZStudent randomStudent],[ZZStudent randomStudent]];
    
    NSInteger newSectionIndex = 0;
    [self.groupsArray insertObject:newStudentGroup atIndex:newSectionIndex];
    
    // обновление таблицы   //[self.tableView reloadData];
    [self.tableView beginUpdates];
    
    NSIndexSet* insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
    
    // анимация для первой группы
    UITableViewRowAnimation animation = UITableViewRowAnimationFade;
    if ([self.groupsArray count] > 1) {
        // чередование анимации
        animation = [self.groupsArray count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    }
    
    [self.tableView insertSections:insertSections
                  withRowAnimation: animation];
    
    [self.tableView endUpdates];
    
    // защита от частого нажимания кнопки в секундах
    UIApplication* app = [UIApplication sharedApplication];
    [app beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([app isIgnoringInteractionEvents]) {
            [app endIgnoringInteractionEvents];
        }
    });
    
    /*
    static BOOL change = YES;
    UIBarButtonSystemItem barButtonStyle;
    
    if (change) {
        barButtonStyle = UIBarButtonSystemItemStop;
        change = NO;
    } else {
        barButtonStyle = UIBarButtonSystemItemAdd;
        change = YES;
    }
    
    UIBarButtonItem* newBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonStyle
                                                                                  target:self
                                                                                  action:@selector(actionAddSection:)];
    [self.navigationItem setRightBarButtonItem:newBarButton animated:YES];
     */
    
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.groupsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    ZZStudentGroup* studentGroup = [self.groupsArray objectAtIndex:section];
    return studentGroup.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ZZStudentGroup* studentGroup = [self.groupsArray objectAtIndex:section];
    return [studentGroup.students count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString* addStudentIdentifier = @"Add student";
        UITableViewCell* addCell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        if (addCell == nil) {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            addCell.textLabel.textColor = [UIColor greenColor];
            addCell.textLabel.text = @"Add student";
        }
        return addCell;
    } // else

    
    // инициализация ячейки
    static NSString* studentIdentifier = @"Student cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifier];
    }
    
    ZZStudentGroup* studentGroup = [self.groupsArray objectAtIndex:indexPath.section];
    ZZStudent* student = [studentGroup.students objectAtIndex:indexPath.row - 1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f", student.averageGrade];
    
    // цвет текста среднего бала
    if (student.averageGrade >= 4) {
        cell.detailTextLabel.textColor = [UIColor greenColor];
    } else if (student.averageGrade >= 3){
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    return cell;
    
    
    /*
    // добавление нового текста в ячейки
    UILabel* mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 220.0, 15.0)];
    mainLabel.font = [UIFont systemFontOfSize:14.0];
    mainLabel.textColor = [UIColor blackColor];
    mainLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    [cell.contentView addSubview:mainLabel];
    */
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    // инициализация для переноса строки таблицы
    ZZStudentGroup* sourceGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    ZZStudentGroup* destinationGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
    ZZStudent* student = [sourceGroup.students objectAtIndex:sourceIndexPath.row - 1];
    
    // удаляем
    NSMutableArray* tempStudentArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    [tempStudentArray removeObject:student];
    sourceGroup.students = tempStudentArray;
    
    // вставляем
    tempStudentArray = [NSMutableArray arrayWithArray:destinationGroup.students];
    
    [tempStudentArray insertObject:student atIndex:destinationIndexPath.row - 1];
    destinationGroup.students = tempStudentArray;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // удаление ячейки
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
            ZZStudentGroup* group = [self.groupsArray objectAtIndex:indexPath.section];
            ZZStudent* student = [group.students objectAtIndex:indexPath.row - 1];
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:group.students];
        
            [tempArray removeObject:student];
            group.students = tempArray;
        
        
            [self.tableView beginUpdates];
            
            //NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:newRowIndex + 1 inSection:indexPath.section];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.tableView endUpdates];
            
            UIApplication* app = [UIApplication sharedApplication];
            [app beginIgnoringInteractionEvents];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([app isIgnoringInteractionEvents]) {
                    [app endIgnoringInteractionEvents];
                }
            });
    }
}


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    ZZStudentGroup* studentGroup = [self.groupsArray objectAtIndex:indexPath.section];
    ZZStudent* student = [studentGroup.students objectAtIndex:indexPath.row];
    
    
    UITableViewCellEditingStyle editStyle;
    
    if (student.averageGrade >= 4) {
        editStyle = UITableViewCellEditingStyleInsert;
    } else if (student.averageGrade >= 3) {
        editStyle = UITableViewCellEditingStyleNone;
    } else {
        editStyle = UITableViewCellEditingStyleDelete;
    }
    return editStyle;
    */
    
    /*
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }
    */
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
    
}

// отступы там где нету знака + или - при редактировании
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO ;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:proposedDestinationIndexPath.section];
    
    if (proposedDestinationIndexPath.row == 0) {
        return indexPath;
    } else {
        return proposedDestinationIndexPath;
    }
    
}

// добавление ячейки с добавлением студента
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        ZZStudentGroup* group = [self.groupsArray objectAtIndex:indexPath.section];
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:group.students];
        
        
        NSInteger newRowIndex = 0;
        [tempArray insertObject:[ZZStudent randomStudent] atIndex:newRowIndex];
        group.students = tempArray;
        
        
        [self.tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:newRowIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
        UIApplication* app = [UIApplication sharedApplication];
        [app beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([app isIgnoringInteractionEvents]) {
                [app endIgnoringInteractionEvents];
            }
        });
        
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"My delete";
}



/*
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction* rowAction1 = [[UITableViewRowAction alloc] init];
    //rowAction1.style = UITableViewRowActionStyleDefault;
    rowAction1.title = @"None";
    rowAction1.backgroundColor = [UIColor greenColor];
    

    
    NSMutableArray* arrayOfRowActions = [NSMutableArray arrayWithObject:rowAction1];
    
    return arrayOfRowActions;
    
}
*/
@end
