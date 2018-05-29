//
//  ViewController.m
//  PropertiesObjC
//
//  Created by zdaecqze zdaecq on 10.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "ViewController.h"
#import "PropertyClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PropertyClass *someClass = [[PropertyClass alloc] init];
    someClass.nameProperty = @"";
    someClass->name = @"qweqwe";
    [someClass setValue: @5 forKey:@"someInt"];
    NSLog(@"%@", [someClass valueForKey:@"someInt"]);
}


@end
