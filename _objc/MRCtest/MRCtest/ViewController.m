//
//  ViewController.m
//  MRCtest
//
//  Created by Bondar Yaroslav on 10/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self someMethod];
}

#pragma mark  - Methods -

-(void)someMethod {
    
    NSString *name = [[NSString alloc] initWithFormat:@"%d", 10];
    NSLog(@"%@", name);
    
    XXXChild *object = [[XXXChild alloc] init];
    object.name = name;
    NSLog(@"%@", object.name);
    [object print];
    
    NSLog(@"object->packageVar %d", object->packageVar);
    
    [name release];
    
    name = object.getSomeStringAutorelease;
//    [name retain];
    NSLog(@"%@", name);
    
//    [name release];
    name = object.getSomeStringRetain;
    NSLog(@"%@", name);
    
    name = object.getSomeStringNormal;
    NSLog(@"%@", name);
    
    
    [object release];
    
    NSString *name1 = [[NSString alloc] initWithFormat:@"%d", 1000000];
    NSLog(@"%@", name1);
}

@end
