//
//  ViewController.m
//  ScheduleShift
//
//  Created by zdaecqze zdaecq on 24.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"

static NSString* ASKeySaveDateBegin = @"dateBegin";
static NSString* ASKeySaveWorkDays = @"workDays";
static NSString* ASKeySaveWeekendDays = @"weekendDays";

@interface ViewController ()

@property (assign, nonatomic) NSInteger workDays;
@property (assign, nonatomic) NSInteger weekendDays;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark Load textFields
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    self.textFieldDateBegin.text = [userDefaults objectForKey:ASKeySaveDateBegin];
    self.textFieldWorkDays.text = [userDefaults objectForKey:ASKeySaveWorkDays];
    self.textFieldWeekendDays.text = [userDefaults objectForKey:ASKeySaveWeekendDays];
    /*
    NSLog(@"%@", self.textFieldDateBegin.text);
    NSLog(@"%@", self.textFieldWorkDays.text);
    NSLog(@"%@", self.textFieldWeekendDays.text);
    */
    // проверка на первый пуск
    if ([self.textFieldDateBegin.text isEqualToString:@""]) {
        self.textFieldDateBegin.text = @"2016/1/3";
        self.textFieldWorkDays.text = @"2";
        self.textFieldWeekendDays.text = @"2";
    }
    
    [self actionButtonTodayTouchUpInside:nil];
    
    [self.textFieldDateToCalculate becomeFirstResponder];
    
}

#pragma mark - Local methods

-(void) calculateResult{
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"y/M/d"];

    NSDate* dateBegin =[dateFormater dateFromString:self.textFieldDateBegin.text];
    NSDate* dateToCalculate =[dateFormater dateFromString:self.textFieldDateToCalculate.text];

    //NSDate* date = [NSDate dateWithTimeInterval:[dateToCalculate timeIntervalSinceDate:dateBegin] sinceDate:dateBegin];
    

    NSCalendar* calender = [NSCalendar currentCalendar];
    
    NSUInteger numberFromDateBegin = [calender ordinalityOfUnit:NSCalendarUnitDay
                                                    inUnit:NSYearCalendarUnit
                                                   forDate:dateBegin];
    
    NSUInteger numberFromDateToCalculate = [calender ordinalityOfUnit:NSCalendarUnitDay
                                                    inUnit:NSYearCalendarUnit
                                                   forDate:dateToCalculate];
    
    NSInteger number = numberFromDateToCalculate - numberFromDateBegin;
    
    
    NSInteger workDays = [self.textFieldWorkDays.text integerValue];
    NSInteger weekendDays = [self.textFieldWeekendDays.text integerValue];
    
    number = number % (workDays + weekendDays);
    
    if (number < workDays ) {
        self.lableResult.text = @"Работа";
    } else {
        self.lableResult.text = @"Выходной";
    }
}


#pragma mark - Actions

- (IBAction)actionTextFieldNumberEditing:(UITextField*)sender {
    
    if (![sender.text isEqualToString:@""]){
        [self calculateResult];
    }
    
    /*
    if ([sender.text isEqualToString:@""]){
        sender.text = @"Здесь будет результат";
        return;
    } else {
        [self calculateResult];
    }
    */

}

- (IBAction)actionButtonTodayTouchUpInside:(UIButton *)sender {
    
    NSDate* dateNow = [NSDate date];
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"y/M/d"];
    
    self.textFieldDateToCalculate.text = [dateFormater stringFromDate:dateNow];
    
    [self calculateResult];

}

- (IBAction)actionButtonTomorrowTouchUpInside:(UIButton *)sender {
    
    // завтра
    NSDate* dateNow = [NSDate date];
    NSInteger daysToAdd = 1;
    NSDate* dateTomorrow = [dateNow dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"y/M/d"];
    
    self.textFieldDateToCalculate.text = [dateFormater stringFromDate:dateTomorrow];

    [self calculateResult];
    
    /*
    // завтра
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
     
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    */
}

- (IBAction)actionTextFieldAnyChanged:(UITextField *)sender {
    
#pragma mark Save textFields
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.textFieldDateBegin.text forKey:ASKeySaveDateBegin];
    [userDefaults setObject:self.textFieldWorkDays.text forKey:ASKeySaveWorkDays];
    [userDefaults setObject:self.textFieldWeekendDays.text forKey:ASKeySaveWeekendDays];
    
    
   // NSLog(@"%@", [userDefaults objectForKey:ASKeySaveDateBegin]);
   // NSLog(@"%@", [userDefaults objectForKey:ASKeySaveWorkDays]);
   // NSLog(@"%@", [userDefaults objectForKey:ASKeySaveWeekendDays]);
    
    [userDefaults synchronize];
    
}

@end
