//
//  ViewController.m
//  CoreDataObjCTest
//
//  Created by zdaecqze zdaecq on 13.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"
#import "CoreDataManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *nameTextView;

@end

#pragma mark - Setup

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameTextView becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.nameTextView resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)saveBarButton:(UIBarButtonItem *)sender {
    
    if ([self.nameTextView.text length] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Task is empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    Task *task = [[Task alloc] init];
    task.name = self.nameTextView.text;
    task.index = @1;
    [[CoreDataManager sharedInstance] saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
