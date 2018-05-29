//
//  ASBattleFieldView.m
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import "ASBattleFieldView.h"

@interface ASBattleFieldView ()

@property (assign, nonatomic) CGRect fieldRect;
@property (assign, nonatomic) CGFloat cellSize;

@end

@implementation ASBattleFieldView

- (void) reloadData {

    [self setNeedsDisplay];
}

- (void) animateShotTo:(CGPoint) coordinate fromRect:(CGRect) rect {
    

    CGRect robotRect = [self rectFromRelativeRect:rect];
    CGRect shotRect = [self rectFromRelativeRect:CGRectMake(coordinate.x, coordinate.y, 1, 1)];
    
    CGPoint start = CGPointMake(CGRectGetMidX(robotRect), CGRectGetMidY(robotRect));
    CGPoint end = CGPointMake(CGRectGetMidX(shotRect), CGRectGetMidY(shotRect));
    
    UIView* bullet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    bullet.backgroundColor = [UIColor redColor];
    bullet.center = start;
    [self addSubview:bullet];
    
    CGFloat distance = sqrt((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y));
    CGFloat speed = 2000;
    
    [UIView animateWithDuration:distance / speed
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         bullet.center = end;
                     }
                     completion:^(BOOL finished) {
                         [bullet removeFromSuperview];
                         [self reloadData];
                     }];
        
    
}

- (CGRect) rectFromRelativeRect:(CGRect) relative {
    
    CGRect rect = CGRectMake(CGRectGetMinX(self.fieldRect) + self.cellSize * CGRectGetMinX(relative),
                             CGRectGetMinY(self.fieldRect) + self.cellSize * CGRectGetMinY(relative),
                             self.cellSize * CGRectGetWidth(relative),
                             self.cellSize * CGRectGetHeight(relative));
    return rect;
}



- (void)drawRect:(CGRect)rect
{
    
    if (!self.dataSource) {
        return;
    }
    
    CGSize fieldSize = [self.dataSource sizeForBattleField:self];
    
    if (fieldSize.width == 0 || fieldSize.height == 0) {
        return;
    }
    
    rect = CGRectInset(rect, 10, 10);
    
    
    // field calculations
    CGFloat cellWidth = floorf(MIN(CGRectGetWidth(rect) / fieldSize.width, CGRectGetHeight(rect) / fieldSize.height));
    
    CGRect fieldRect = CGRectMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect) - cellWidth * fieldSize.width) / 2,
                                  CGRectGetMinY(rect) + (CGRectGetHeight(rect) - cellWidth * fieldSize.height) / 2,
                                  cellWidth * fieldSize.width,
                                  cellWidth * fieldSize.height);
    
    fieldRect = CGRectIntegral(fieldRect);
    
    self.fieldRect = fieldRect;
    self.cellSize = cellWidth;
    
    // field drawing
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.f);
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    for (int i = 0; i < fieldSize.width + 1; i++) {
        CGContextMoveToPoint(context, CGRectGetMinX(fieldRect) + cellWidth * i, CGRectGetMinY(fieldRect));
        CGContextAddLineToPoint(context, CGRectGetMinX(fieldRect) + cellWidth * i, CGRectGetMaxY(fieldRect));
    }
    
    for (int i = 0; i < fieldSize.height + 1; i++) {
        CGContextMoveToPoint(context, CGRectGetMinX(fieldRect), CGRectGetMinY(fieldRect) + cellWidth * i);
        CGContextAddLineToPoint(context, CGRectGetMaxX(fieldRect), CGRectGetMinY(fieldRect) + cellWidth * i);
    }
    
    
    CGContextStrokePath(context);
    
    // robots drawing
    NSInteger robotsNumber = [self.dataSource numberOfRobotsOnBattleField:self];
    for (int i = 0; i < robotsNumber; i++) {
        
        CGRect robotRect = [self.dataSource battleField:self rectForRobotAtIndex:i];
        robotRect = [self rectFromRelativeRect:robotRect];
        
        UIColor* robotColor = nil;
        
        if ([self.dataSource respondsToSelector:@selector(battleField:colorForRobotAtIndex:)]) {
            robotColor = [self.dataSource battleField:self colorForRobotAtIndex:i];
        }
        
        if (!robotColor) {
            robotColor = [UIColor blackColor];
        }
        
        CGContextSetFillColorWithColor(context, robotColor.CGColor);
        CGContextSetStrokeColorWithColor(context, robotColor.CGColor);
        
        CGContextAddRect(context, robotRect);
        CGContextFillPath(context);
        
    }
    
    // shots drawing
    NSInteger shotsNumber = [self.dataSource numberOfShotsOnBattleField:self];
    for (int i = 0; i < shotsNumber; i++) {
        
        CGPoint shotCoord = [self.dataSource battleField:self shotCoordinateAtIndex:i];
        
        CGRect rect = CGRectMake(CGRectGetMinX(fieldRect) + cellWidth * shotCoord.x,
                                 CGRectGetMinY(fieldRect) + cellWidth * shotCoord.y,
                                 cellWidth, cellWidth);
        
        BOOL hit = NO;
        
        for (int j = 0; j < robotsNumber; j++) {
            
            CGRect robotRect = [self.dataSource battleField:self rectForRobotAtIndex:j];
            
            if (CGRectContainsPoint(robotRect, shotCoord)) {
                hit = YES;
                break;
            }
            
        }
        
        UIColor * color = hit ? [UIColor redColor] : [UIColor lightGrayColor];
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGContextAddRect(context, rect);
        CGContextFillPath(context);
    }

    // text drawing
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowBlurRadius = 2;
    shadow.shadowColor = [UIColor blackColor];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    
    for (int i = 0; i < robotsNumber; i++) {
        
        CGRect robotRect = [self.dataSource battleField:self rectForRobotAtIndex:i];
        robotRect = [self rectFromRelativeRect:robotRect];
        
        NSString* name = [self.dataSource battleField:self nameForRobotAtIndex:i];
        
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:20.f], NSFontAttributeName,
                                    [UIColor whiteColor], NSStrokeColorAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    shadow, NSShadowAttributeName,
                                    paragraph, NSParagraphStyleAttributeName,
                                    nil];
        
        [name drawInRect:robotRect withAttributes:attributes];
        
        
    }
    
}


@end
