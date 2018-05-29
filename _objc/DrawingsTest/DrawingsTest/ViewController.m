//
//  ViewController.m
//  DrawingsTest
//
//  Created by zdaecqze zdaecq on 14.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"
#import "ASDrawingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.drawingView setNeedsDisplay];
}

@end
