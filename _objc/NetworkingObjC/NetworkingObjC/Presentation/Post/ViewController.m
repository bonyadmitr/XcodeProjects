//
//  ViewController.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "ViewController.h"
#import "PostView.h"

#warning rename to PostController
@interface ViewController ()
@property (weak, nonatomic) IBOutlet PostView *postView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.postView fillWith:self.post];
}

@end
