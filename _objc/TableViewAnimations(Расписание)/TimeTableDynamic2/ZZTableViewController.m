//
//  ZZTableViewController.m
//  TimeTableDynamic2
//
//  Created by zdaecqze zdaecq on 31.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ZZTableViewController.h"
#import "ZZClass.h"
#import "ZZDay.h"


@interface ZZTableViewController ()

@property (strong,nonatomic) NSArray* week;
@property (strong,nonatomic) NSArray* weekWithNotNilDays;

@property (assign,nonatomic) BOOL isEditing;
@property (assign,nonatomic) BOOL addNewClass;


@end

@implementation ZZTableViewController

-(void)loadView{
    [super loadView];
    
    //ZZClass* class1 = [ZZClass randomClass];
    //ZZClass* class2 = [ZZClass randomClass];
    

    ZZDay* day1 = [[ZZDay alloc] init];
    day1.name = @"Понедельник";
    day1.headerColor = [UIColor colorWithRed:1 green:0.25 blue:0.25 alpha:1]; // красный
    day1.classesArray = [NSMutableArray array];
    //[day1.classesArray addObject:class1];
    //[day1.classesArray addObject:class2];
    
    ZZDay* day2 = [[ZZDay alloc] init];
    day2.name = @"Вторник";
    day2.headerColor = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1]; // оранжевый
    day2.classesArray = [NSMutableArray array];
    //[day2.classesArray addObject:class1];
    
    ZZDay* day3 = [[ZZDay alloc] init];
    day3.name = @"Среда";
    day3.headerColor = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:1]; // желтный
    day3.classesArray = [NSMutableArray array];
    //[day3.classesArray addObject:class1];
    
    ZZDay* day4 = [[ZZDay alloc] init];
    day4.name = @"Четверг";
    day4.headerColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.2 alpha:1]; // зеленый
    day4.classesArray = [NSMutableArray array];
    //[day4.classesArray addObject:class1];
    
    ZZDay* day5 = [[ZZDay alloc] init];
    day5.name = @"Пятница";
    day5.headerColor = [UIColor colorWithRed:0 green:0.75 blue:1 alpha:1]; // голубой
    day5.classesArray = [NSMutableArray array];
    //[day5.classesArray addObject:class1];
    
    ZZDay* day6 = [[ZZDay alloc] init];
    day6.name = @"Суббота";
    day6.headerColor = [UIColor colorWithRed:0 green:0.3 blue:1 alpha:1]; // синий
    day6.classesArray = [NSMutableArray array];
    //[day6.classesArray addObject:class1];
    
    ZZDay* day7 = [[ZZDay alloc] init];
    day7.name = @"Воскресенье";
    day7.headerColor = [UIColor colorWithRed:0.5 green:0.1 blue:1 alpha:1]; // фиолетовый
    day7.classesArray = [NSMutableArray array];
    //[day7.classesArray addObject:class1];
    //[day7.classesArray addObject:class1];
    //[day7.classesArray addObject:class1];
    //[day7.classesArray addObject:class1];
        
        
    self.week = @[day1, day2, day3, day4, day5, day6, day7];
    [self countNumberOfNotNilDaysInWeek];
    
    self.isEditing = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                              target:self
                                              action:@selector(actionEditTable:)];
}


#pragma mark - Actions

// нажатие на кнопку редактирования
-(void)actionEditTable:(UIBarButtonItem*)sender{
    
    
    // инициализация переменных пустыми значениями
    NSMutableIndexSet* insertSections = [[NSMutableIndexSet alloc] init];
    ZZDay* day = nil;
    
    NSMutableArray* arrayOfInsertRows = [[NSMutableArray alloc] init];
    NSInteger classesArrayCount = 0;
    NSIndexPath* inserRowPath = nil;
    
    // считаем номера дней без занятий и записываем их индексы
    for (int i = 0; i < 7; i++) {
        
        day = [self.week objectAtIndex:i];
        
        classesArrayCount = [day.classesArray count];
        inserRowPath = [NSIndexPath indexPathForRow:classesArrayCount inSection:i];
        [arrayOfInsertRows addObject:inserRowPath];
        
        if (classesArrayCount == 0) {
            [insertSections addIndex:i];
        }
    }
    
    
    // таблица перейдет в режим редактирования. добавление секций и ячеек
    if (self.isEditing == NO) {
        self.isEditing = YES;
        
        
        [self.tableView beginUpdates];
        
        // эти методы считают сразу новые секцие и новые строчки
        [self.tableView insertSections:insertSections withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView insertRowsAtIndexPaths:arrayOfInsertRows withRowAnimation:UITableViewRowAnimationLeft];

        [self.tableView endUpdates];
        
        
        [self.tableView setEditing:YES animated:YES];

    // таблица выйдет из режима редактирования. удаление ячеек и секций
    } else {
        self.isEditing = NO;
        
    
        [self.tableView beginUpdates];
        
        [self.tableView deleteSections:insertSections withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView deleteRowsAtIndexPaths:arrayOfInsertRows withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
        
        
        [self.tableView setEditing:NO animated:YES];
    }
    
    // пауза на все жести от быстро включения/выключения режима редактирования
    UIApplication* app = [UIApplication sharedApplication];
    [app beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([app isIgnoringInteractionEvents]) {
            [app endIgnoringInteractionEvents];
        }
    });
}

#pragma mark - Local methods

-(void) countNumberOfNotNilDaysInWeek{
    
    NSMutableArray* tempArray = [NSMutableArray array];
    ZZDay* day = nil;
    
    for (int i = 0; i < 7; i++) {
        day = [self.week objectAtIndex:i];
        if ([day.classesArray count] != 0) {
            [tempArray addObject:day];
        }
    }
    
    //[NSString stringWithFormat:@"%d", [day.classesArray count]];
    
    self.weekWithNotNilDays = tempArray;
    
    //NSLog(@"%d", [self.weekWithNotNilDays count]);
}


#pragma mark - UITableViewDelegate
#pragma mark UITableViewDataSource


#pragma mark - Section

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.isEditing == YES) {
        return 7;
    }
    
    return [self.weekWithNotNilDays count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    // изменение цвета заголовка секции
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    
    if (self.isEditing == YES){
        ZZDay* day = [self.week objectAtIndex:section];
        headerView.backgroundView.backgroundColor = day.headerColor;
    } else {
        ZZDay* day = [self.weekWithNotNilDays objectAtIndex:section];
        headerView.backgroundView.backgroundColor = day.headerColor;
    }
    //headerView.backgroundView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
    
    // изменение цвета текста заголовка секции
    [headerView.textLabel setTextColor:[UIColor whiteColor]];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (self.isEditing == YES){
        ZZDay* day = [self.week objectAtIndex:section];
        return day.name;
    }
    
    ZZDay* day = [self.weekWithNotNilDays objectAtIndex:section];
    return day.name;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isEditing == YES){
        ZZDay* day = [self.week objectAtIndex:section];
        NSInteger numberOfClasses = [day.classesArray count];
        
        // для ячейки с "+" (ячейка добавления нового занятия)
        numberOfClasses++;

        return numberOfClasses;
    }
    
    ZZDay* day = [self.weekWithNotNilDays objectAtIndex:section];
    NSInteger numberOfClasses = [day.classesArray count];
    
    return numberOfClasses;
}


#pragma mark - Cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.isEditing == YES){
        
        ZZDay* day = [self.week objectAtIndex:indexPath.section];
        
        // для рисования последней ячейки добавления
        //int i = indexPath.row;
        //int w = [day.classesArray count];
        if (indexPath.row == [day.classesArray count]) {
            
            static NSString* indentifierCell = @"Add class";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierCell];
            }
            
            cell.textLabel.text = @"Добавить занятие";
            
            return cell;
        }
        
        // эту часть нельзя объединить с тем что ниже (они очень похожи) т.к. отличаются ZZDay* day
        static NSString* indentifierCell = @"Class";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifierCell];
        }
        
        ZZClass* class = [day.classesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Class: %@", class.nameOfClass];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Teacher: %@", class.nameOfTeacher];
        
        return cell;
    }
    
    
    static NSString* indentifierCell = @"Class";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifierCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifierCell];
    }
    
    ZZDay* day = [self.weekWithNotNilDays objectAtIndex:indexPath.section];
    ZZClass* class = [day.classesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Class: %@", class.nameOfClass];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Teacher: %@", class.nameOfTeacher];
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCellEditingStyle editStyle = UITableViewCellEditingStyleDelete; // для всех по умолчанию сохраняем
    ZZDay* day = [self.week objectAtIndex:indexPath.section];
    
    // ставим "+" для последней ячейки (добавления занятия)
    if (indexPath.row == [day.classesArray count]) {
        editStyle = UITableViewCellEditingStyleInsert;
    }
    
    return editStyle;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // изменение цвета чередующейся ячейки
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:1 alpha:1];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // удаление ячейки
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        ZZDay* day = [self.week objectAtIndex:indexPath.section];
        [day.classesArray removeObjectAtIndex:indexPath.row];
        [self countNumberOfNotNilDaysInWeek];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        
    // добавление ячейки
    } else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        ZZClass* class = [ZZClass randomClass];
        ZZDay* day = [self.week objectAtIndex:indexPath.section];
        [day.classesArray addObject:class];
        [self countNumberOfNotNilDaysInWeek];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
}

// убираем удаление свайпом при просмотре таблицы
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.isEditing;
}




@end
