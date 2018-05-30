//
//  ViewController.m
//  GesturesTest
//
//  Created by zdaecqze zdaecq on 13.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView* testView;
@property (assign, nonatomic) CGFloat scaleTestView;
@property (assign, nonatomic) CGFloat rotationTestView;
@property (assign, nonatomic) CGPoint deltaCenterPoint;

//@property (strong, nonatomic) NSMutableArray* colorSaveArray;
@property (strong, nonatomic) NSMutableArray* historyArray;
@property (assign, nonatomic) NSInteger historyIndex;

@end

@implementation ViewController

-(UIColor*) randomColor
{
    CGFloat r = (float)(arc4random() % 256) / 255;
    CGFloat g = (float)(arc4random() % 256) / 255;
    CGFloat b = (float)(arc4random() % 256) / 255;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    CGFloat viewWidth = 200;
    CGFloat viewHeigth = 200;
    UIView* view = [[UIView alloc] initWithFrame:
                    CGRectMake(CGRectGetMidX(self.view.bounds) - viewWidth/2, CGRectGetMidY(self.view.bounds) - viewHeigth/2, viewWidth, viewHeigth)];
    view.backgroundColor = [UIColor redColor];
//    self.colorSaveArray = [NSMutableArray array];
    self.historyArray = [NSMutableArray arrayWithObject:[UIColor redColor]];
    self.historyIndex = 0;
    
    [self.view addSubview:view];
    self.testView = view;
    
    UITapGestureRecognizer* oneTapDoubleTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapDoubleTouchGestureMethod:)];
    //doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    oneTapDoubleTouchGesture.numberOfTouchesRequired = 2;
    [self.testView addGestureRecognizer:oneTapDoubleTouchGesture];
    
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapMethod:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.view addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMethod:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightMethod:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchMethod:)];
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationMethod:)];
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
    
    //UIPanGestureRecognizer* panGeture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
    //[self.testView addGestureRecognizer:panGeture];
    
    UILongPressGestureRecognizer* longPressGeture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    [self.testView addGestureRecognizer:longPressGeture];

}

#pragma mark - Gestures

-(void) tapMethod: (UITapGestureRecognizer*) tapGesture{
    NSLog(@"Tap %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    /*
    CGPoint pointInsideView = [tapGesture locationInView:self.testView];
    if ([self.testView pointInside:pointInsideView withEvent:nil]){
        NSLog(@"Tap inside testView %@", NSStringFromCGPoint(pointInsideView));
        [UIView animateWithDuration:0.3f
                         animations:^{
                            self.testView.transform = CGAffineTransformScale(self.testView.transform, 1.2f, 1.2f);
                         }];
    }
     */
}


-(void) doubleTapMethod: (UITapGestureRecognizer*) doubleTapGesture{
    NSLog(@"Double tap %@", NSStringFromCGPoint([doubleTapGesture locationInView:self.view]));
    
    CGPoint pointInsideView = [doubleTapGesture locationInView:self.testView];
    if ([self.testView pointInside:pointInsideView withEvent:nil]){
        NSLog(@"Double tap inside testView %@", NSStringFromCGPoint(pointInsideView));
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.testView.transform = CGAffineTransformScale(self.testView.transform, 1.2f, 1.2f);
                         }];
    }

}


-(void) oneTapDoubleTouchGestureMethod: (UITapGestureRecognizer*) oneTapDoubleTouchGestureGesture{
    //NSLog(@"doubleTapDoubleTouchGesture %@", NSStringFromCGPoint([doubleTapDoubleTouchGestureGesture locationInView:self.view]));
    
    //CGPoint pointInsideView = [doubleTapDoubleTouchGestureGesture locationInView:self.testView];
    //if ([self.testView pointInside:pointInsideView withEvent:nil]){
        //NSLog(@"doubleTapDoubleTouch inside testView %@", NSStringFromCGPoint(pointInsideView));
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.testView.transform = CGAffineTransformScale(self.testView.transform, 0.8f, 0.8f);
                         }];
        
    //}
}


// возврат назад по истории цветов в массиве
-(void) swipeLeftMethod: (UITapGestureRecognizer*) swipeLeftGesture{
    NSLog(@"swipe %@", NSStringFromCGPoint([swipeLeftGesture locationInView:self.view]));
    
    CGPoint pointInsideView = [swipeLeftGesture locationInView:self.testView];
    if ([self.testView pointInside:pointInsideView withEvent:nil]){
        NSLog(@"Swipe inside testView %@", NSStringFromCGPoint(pointInsideView));
        [UIView animateWithDuration:0.3f
                         animations:^{
                             if (self.historyIndex != 0) {
                                 self.historyIndex--;
                                 self.testView.backgroundColor = [self.historyArray objectAtIndex:self.historyIndex];
                             }
                             
                             
                             /*
                             self.testView.backgroundColor = [self.colorSaveArray lastObject];
                             if (![[self.colorSaveArray lastObject] isEqual:[self.self.colorSaveArray objectAtIndex:0]])
                                 [self.colorSaveArray removeObject:[self.colorSaveArray lastObject]];
                              */
                         }];
    }
}


// добвляет новый случайный цвет на фон или возврат вперед в массиве истории цветов
-(void) swipeRightMethod: (UITapGestureRecognizer*) swipeRightGesture{
    NSLog(@"swipe %@", NSStringFromCGPoint([swipeRightGesture locationInView:self.view]));
    
    CGPoint pointInsideView = [swipeRightGesture locationInView:self.testView];
    if ([self.testView pointInside:pointInsideView withEvent:nil]){
        NSLog(@"Swipe inside testView %@", NSStringFromCGPoint(pointInsideView));
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.historyIndex++;
                             if ([self.historyArray count] == self.historyIndex) {
                                 UIColor* color = [self randomColor];
                                 [self.historyArray addObject:color];
                                 self.testView.backgroundColor = color;
                             } else {
                                 self.testView.backgroundColor = [self.historyArray objectAtIndex:self.historyIndex];
                             }

                             
                             /*
                             [self.colorSaveArray addObject:self.testView.backgroundColor];
                             self.testView.backgroundColor = [self randomColor];
                              */
                             
                         }];
    }
}


-(void) pinchMethod: (UIPinchGestureRecognizer*) pinchGesture{
    NSLog(@"pinchGesture: %f", pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.scaleTestView = 1.f;
    }
    CGFloat newScale = 1 + pinchGesture.scale - self.scaleTestView;
    self.testView.transform = CGAffineTransformScale(self.testView.transform, newScale, 1+pinchGesture.scale-self.scaleTestView);
    self.scaleTestView = pinchGesture.scale;
}



-(void) rotationMethod: (UIRotationGestureRecognizer*) rotationGesture{
    NSLog(@"rotationMethod: %f", rotationGesture.rotation);
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.rotationTestView = 0;
    }
    CGFloat newRotation = rotationGesture.rotation - self.rotationTestView;
    self.testView.transform = CGAffineTransformRotate(self.testView.transform, newRotation);
    self.rotationTestView = rotationGesture.rotation;
}

/*
-(void) panMethod: (UIPanGestureRecognizer*) panGesture{
    CGPoint pointInside = [panGesture locationInView:self.view];
    NSLog(@"panGesture: %@", NSStringFromCGPoint(pointInside));
    
    //if ([self.testView pointInside:[panGesture locationInView:self.testView] withEvent:nil]){
        if (panGesture.state == UIGestureRecognizerStateBegan) {
            self.deltaCenterPoint = CGPointMake(self.testView.center.x - pointInside.x, self.testView.center.y - pointInside.y);
        }
        
        self.testView.center = CGPointMake(pointInside.x + self.deltaCenterPoint.x, pointInside.y + self.deltaCenterPoint.y);
    //}
}
*/


-(void) longPressMethod: (UIPanGestureRecognizer*) longPressGesture{
    CGPoint pointInside = [longPressGesture locationInView:self.view];
    NSLog(@"longPressGesture: %@", NSStringFromCGPoint(pointInside));
    
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.3f animations:^{
            self.testView.alpha = 0.5f;
            self.testView.transform = CGAffineTransformScale(self.testView.transform, 1.2, 1.2);
        }];
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3f animations:^{
            self.testView.alpha = 1;
            self.testView.transform = CGAffineTransformScale(self.testView.transform, 0.8f, 0.8f);
        }];

    }
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        self.deltaCenterPoint = CGPointMake(self.testView.center.x - pointInside.x, self.testView.center.y - pointInside.y);
    }
    
    self.testView.center = CGPointMake(pointInside.x + self.deltaCenterPoint.x, pointInside.y + self.deltaCenterPoint.y);
}

#pragma mark - UIGestureRecognizerDelegate
// для того чтобы работали одновременно rotationGesture и pinchGesture установили им delegate и этот метод
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
