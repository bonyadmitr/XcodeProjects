//
//  ViewController.h
//  ScheduleShift
//
//  Created by zdaecqze zdaecq on 24.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lableResult;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateToCalculate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateBegin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWorkDays;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWeekendDays;

- (IBAction)actionTextFieldNumberEditing:(UITextField*)sender;
- (IBAction)actionButtonTodayTouchUpInside:(UIButton *)sender;
- (IBAction)actionButtonTomorrowTouchUpInside:(UIButton *)sender;
- (IBAction)actionTextFieldAnyChanged:(UITextField *)sender;

@end

