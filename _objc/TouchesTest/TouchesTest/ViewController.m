//
//  ViewController.m
//  TouchesTest
//
//  Created by zdaecqze zdaecq on 12.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(weak, nonatomic) UIView* selfMadeView;
@property(weak, nonatomic) UIView* draggingView;
@property(assign, nonatomic) CGPoint deltaCenterPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    [self.testView addSubview:view];
    self.selfMadeView = view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    view.backgroundColor = [UIColor blueColor];
    [self.testView addSubview:view];
    self.selfMadeView = view;
    
    //self.view.multipleTouchEnabled = YES;
}

#pragma mark - Touches

-(void) logTouch:(NSSet*)touchSet withMethodName:(NSString*) methodName{

    NSMutableString* string = [NSMutableString stringWithString:methodName];
    CGPoint touchPoint;
    for (UITouch* touch in touchSet){
        touchPoint = [touch locationInView:self.view];
        [string appendFormat:@" %@", NSStringFromCGPoint(touchPoint)];
    }
    
    NSLog(@"%@",string);
}

-(void) touchEnded{
    [UIView animateWithDuration:0.3f animations:^{
        self.draggingView.transform = CGAffineTransformMakeScale(1, 1);
        self.draggingView.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self logTouch:touches withMethodName:@"touchesBegan"];

    UITouch* touch = [touches anyObject];
    
    CGPoint pointInside = [touch locationInView:self.selfMadeView];
    NSLog(@"inside: %d", [self.selfMadeView pointInside:pointInside withEvent:event]);
    
    
    pointInside = [touch locationInView:self.view];
    UIView* view = [self.view hitTest:pointInside withEvent:event];
    
    if (![view isEqual:self.view]) {
        [self.view bringSubviewToFront:view];
        self.draggingView = view;
        [UIView animateWithDuration:0.3f animations:^{
            self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
            self.draggingView.alpha = 0.5f;
        }];
        
        self.deltaCenterPoint = CGPointMake(view.center.x - pointInside.x, view.center.y - pointInside.y);
    } else {
        self.draggingView = nil;
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self logTouch:touches withMethodName:@"touchesMoved"];
    
    UITouch* touch = [touches anyObject];
    CGPoint pointInside = [touch locationInView:self.view];
    self.draggingView.center = CGPointMake(pointInside.x + self.deltaCenterPoint.x, pointInside.y + self.deltaCenterPoint.y);

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self logTouch:touches withMethodName:@"touchesEnded"];
    
    [self touchEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self logTouch:touches withMethodName:@"touchesCancelled"];
    
    [self touchEnded];
}


@end
