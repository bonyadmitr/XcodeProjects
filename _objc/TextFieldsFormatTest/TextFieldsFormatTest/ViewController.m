//
//  ViewController.m
//  TextFieldsFormatTest
//
//  Created by zdaecqze zdaecq on 19.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textFieldPhone becomeFirstResponder];
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // получить +XXX (XXX) XXX-XX-XX или то что долно выйти
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // проверка на ограничение длины номера
    if ([newString length] > 0) {
        
        //для +7 (XXX) XXX-XX-XX
        if ([newString characterAtIndex:0] == '+') {
            
            if ([newString length] > 18) {
                return NO;
            }
            
            // для 8 (XXX) XXX-XX-XX
        } else if ([newString characterAtIndex:0] == '8'){
            
            if ([newString length] > 17) {
                return NO;
            }
        }
    }
    
    // чтобы писались только цифры и знаки нужные
    NSCharacterSet* validationSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+*#"] invertedSet];
    NSArray* componentsOfString = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([componentsOfString count] > 1) {
        return NO;
    }
    
    // получить XXXXXXXXXXXXX
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];

    
    
    /*
    // чтобы писались только. цифры сам написал
    unichar charInString = 0;
    for (int i = 0; i < [string length]; i++) {
        charInString = [string characterAtIndex:i];
        if (charInString < 48 || charInString > 58) {
            return NO;
        }
    }
    */
    
    NSMutableString* resultString = [NSMutableString stringWithString:newString];
    
    // константы для индексов положения спец символов нашего форматирования
    static const NSInteger indexOfLeftBracket = 1;
    static const NSInteger indexOfRightBracket = 6;
    static const NSInteger indexOfFirstDash = 11;
    static const NSInteger indexOfSecondDash = 14;
    
    // создание номера
    if ([resultString length] > 0) {
        
        // по типу 8 (XXX) XXX-XX-XX
        if ([resultString characterAtIndex:0] == '8'){
            
            if ([resultString length] > indexOfLeftBracket) {
                [resultString insertString:@" (" atIndex:indexOfLeftBracket];
            }
            
            if ([resultString length] > indexOfRightBracket) {
                [resultString insertString:@") " atIndex:indexOfRightBracket];
            }
            
            if ([resultString length] > indexOfFirstDash) {
                [resultString insertString:@"-" atIndex:indexOfFirstDash];
            }
            
            if ([resultString length] > indexOfSecondDash) {
                [resultString insertString:@"-" atIndex:indexOfSecondDash];
            }
            
        // по типу +7 (XXX) XXX-XX-XX
        } else if ([resultString length] > 1 && [[resultString substringToIndex:2]isEqual:@"+7"]){
            
            if ([resultString length] > indexOfLeftBracket+1) {
                [resultString insertString:@" (" atIndex:indexOfLeftBracket+1];
            }
            
            if ([resultString length] > indexOfRightBracket+1) {
                [resultString insertString:@") " atIndex:indexOfRightBracket+1];
            }
            
            if ([resultString length] > indexOfFirstDash+1) {
                [resultString insertString:@"-" atIndex:indexOfFirstDash+1];
            }
            
            if ([resultString length] > indexOfSecondDash+1) {
                [resultString insertString:@"-" atIndex:indexOfSecondDash+1];
            }
        }
    }

    
    /*
    if ([resultString length] > 3) {
        [resultString insertString:@"-" atIndex:3];
    }
    
    if ([resultString length] > 6) {
        [resultString insertString:@"-" atIndex:6];
    }
    */
    
    /*
    if ([newString length] > 3 && [newString length] < 6) {
        //[resultString insertString:@"-" atIndex:0];
        newString = [newString stringByAppendingString:@"-"];
    }
    */
    textField.text = resultString;
    
    return NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
