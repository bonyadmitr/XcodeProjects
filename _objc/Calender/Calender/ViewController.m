//
//  ViewController.m
//  Calender
//
//  Created by zdaecqze zdaecq on 27.02.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"


@interface ViewController ()

@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSDate* tempDate;
@property (assign, nonatomic) NSInteger firstDayIndexOfMonth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentDate = [NSDate date];
    [self updateFirstDayIndexOfMonth];
    
    /*
    NSDate* dateNow = [NSDate date];
    
    NSInteger daysToAdd = 1;
    NSDate* dateTomorrow = [dateNow dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    NSLog(@"date: %@", dateNow);
    NSLog(@"dateTomorrow: %@", dateTomorrow);
    
    
    //NSCalendar
    NSCalendar* calender = [NSCalendar currentCalendar];
    
    NSUInteger days = [calender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateNow];
    NSLog(@"days in date: %d", days);
    
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateNow];
    NSInteger daysInMonth = range.length;
    NSLog(@"daysInMonth: %d", daysInMonth);
    
    
    
    //NSDateFormatter
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"d MMMM y"];
    NSLog(@"dateFormater: %@", [dateFormater stringFromDate:dateNow]);
    
    [dateFormater setDateFormat:@"d LLLL y"];
    NSLog(@"dateFormater: %@", [dateFormater stringFromDate:dateNow]);
    
    //NSDateComponents
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateNow];
    NSLog(@"dateComponents: %d %d %d", [components day], [components month], [components year]);
     */
    
}

#pragma mark - Actions

- (IBAction)actionNextMonth:(UIButton *)sender {
    
    self.currentDate = [self addMonthToDate:self.currentDate for:1];
    [self updateFirstDayIndexOfMonth];
    
    [self.collectionView reloadData];
}

- (IBAction)actionPreviousMonth:(UIButton *)sender {
    
    self.currentDate = [self addMonthToDate:self.currentDate for:-1];
    [self updateFirstDayIndexOfMonth];
    
    [self.collectionView reloadData];
}

- (IBAction)actionCurrentMonth:(UIButton *)sender {
    
    self.currentDate = [NSDate date];
    [self updateFirstDayIndexOfMonth];
    
    [self.collectionView reloadData];
}



#pragma mark - Calender methods

-(NSInteger) getDayCountInMonthOfDate:(NSDate*) date {

    NSCalendar* calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate];
    
    return range.length;
}

-(NSInteger) getDayIndexOfDate:(NSDate*) date {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    return [calender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
}

-(NSDateComponents*) getComponentsForDate:(NSDate*) date {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    return [calender components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSCalendarUnitMinute fromDate:date];
    
}

-(NSDate*) addMonthToDate:(NSDate*) date for:(NSInteger)number {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* components = [self getComponentsForDate:self.currentDate];
    components.month += number;
    
    return [calender dateFromComponents:components];
}



-(BOOL) isEqualDateByMonthAndYear:(NSDate*) date1 withDate:(NSDate*) date2{
    
    NSDateComponents* components1 = [self getComponentsForDate:date1];
    NSDateComponents* components2 = [self getComponentsForDate:date2];
    
    return (components1.year == components2.year) && (components1.month  == components2.month);
}

-(void) updateFirstDayIndexOfMonth {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [self getComponentsForDate:self.currentDate];
    components.day = 1;
    self.tempDate = [calender dateFromComponents:components];
    
    //первый вариант
    [calender setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    self.firstDayIndexOfMonth = [calender ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self.tempDate];
    
    // второй вариант
    /*
    components = [calender components:NSWeekdayCalendarUnit fromDate:self.tempDate];
    self.firstDayIndexOfMonth = ((components.weekday + 5) % 7) + 1;
    
     // вместо ((components.weekday + 5) % 7) + 1; можно использовать вот это:
//    if (self.firstDayIndexOfMonth > 1)
//        self.firstDayIndexOfMonth--;
//    else
//        self.firstDayIndexOfMonth = 7;
    */

    
    //NSLog(@"firstDayOfMonth: %d", self.firstDayIndexOfMonth);
}

-(NSInteger) getDayForIndexPath:(NSIndexPath*)indexPath {
    return indexPath.row + 2 - self.firstDayIndexOfMonth;
}



#pragma mark - UICollectionView
//UICollectionViewDelegate
//UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self getDayCountInMonthOfDate:self.currentDate] + self.firstDayIndexOfMonth - 1;
}

//отображение ячейки
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* const cellIdentifier = @"DayCell";
    static NSString* const emptyCellIdentifier = @"EmptyCell";
    
    if (indexPath.row + 1 < self.firstDayIndexOfMonth) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emptyCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = collectionView.backgroundColor;
        return cell;
    }
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSInteger dayToDisplay = [self getDayForIndexPath:indexPath];
    
    //если совпадают год - месяц и день с ячейкой
    if ([self isEqualDateByMonthAndYear:self.currentDate withDate:[NSDate date]] &&
        [self getDayIndexOfDate:self.currentDate] == dayToDisplay) {
        
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.cornerRadius = 5.f;
    cell.layer.masksToBounds = YES;
    
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)dayToDisplay];
    
    return cell;
}

//отображение хедера
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        static NSString* const headerIdentifier = @"HeaderCell";
        CollectionReusableView* headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy LLLL"]; //LLLL как MMMM только чтобы использовать в именительном падеже месяца
        
        headerCell.label.text = [[dateFormater stringFromDate:self.currentDate] capitalizedString];
        
        return headerCell;
    }
    
    return nil;
}

//когда дотронулись до ячейки
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //проверка, чтобы не получать действия для пустых ячеек
    if (indexPath.row + 2 > self.firstDayIndexOfMonth) {
        
        NSDateComponents* components = [self getComponentsForDate:self.currentDate];
        
        components.day = [self getDayForIndexPath:indexPath];
        
        NSCalendar* calender = [NSCalendar currentCalendar];
        NSDate* cellDate = [calender dateFromComponents:components];
        

        NSTimeZone* gmt = [NSTimeZone systemTimeZone];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm";
        [dateFormatter setTimeZone:gmt];
        NSString* timeStamp = [dateFormatter stringFromDate:cellDate];
        
        [[[UIAlertView alloc] initWithTitle:@"Date"
                                    message:timeStamp //[NSString stringWithFormat: @"%@", cellDate]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

}



@end






















