//
//  ViewController.m
//  UIDynamicAnimatorTest
//
//  Created by zdaecqze zdaecq on 22.09.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *boxView;

@end

@implementation ViewController {
    UIView *barrier;
    UIGravityBehavior *gravity;
    UIDynamicAnimator *animator;
    UICollisionBehavior *collision;
    UIDynamicItemBehavior *itemBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    self.boxView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.boxView];
    
    barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor blackColor];
    [self.view addSubview:barrier];
    
    
    
    gravity = [[UIGravityBehavior alloc] initWithItems:@[self.boxView]];
    gravity.magnitude = 1;
    
    collision = [[UICollisionBehavior alloc] initWithItems:@[self.boxView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    //--- add barrier collision
    CGPoint rightPoint = CGPointMake(barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y);
    [collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:rightPoint];
    
    //--- view elasticity and etc.
    itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.boxView]];
    itemBehavior.elasticity = 0.3;
    
    
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [animator addBehavior:gravity];
    [animator addBehavior:collision];
    [animator addBehavior:itemBehavior];
    
    
    __weak typeof(self) weakSelf = self;
    [collision setAction:^{
        UIView *newBox = [[UIView alloc] initWithFrame:weakSelf.boxView.frame];
        newBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
        newBox.layer.borderWidth = 1;
        newBox.transform = weakSelf.boxView.transform;
        newBox.center = newBox.center;
        [weakSelf.view insertSubview:newBox belowSubview:weakSelf.boxView];
        
        if (self.view.subviews.count > 50) {
            UIView *firstView = weakSelf.view.subviews[2];
            [firstView removeFromSuperview];
        }
    }];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.boxView addGestureRecognizer:tapGesture];
}

-(void)tapAction:(UITapGestureRecognizer *)sender
{
    [itemBehavior addLinearVelocity:CGPointMake(0, -300) forItem: self.boxView];
    [itemBehavior addAngularVelocity:5 forItem:self.boxView];
}


@end
