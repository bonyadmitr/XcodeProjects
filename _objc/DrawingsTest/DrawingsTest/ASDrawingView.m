//
//  ASDrawingView.m
//  DrawingsTest
//
//  Created by zdaecqze zdaecq on 14.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ASDrawingView.h"

@implementation ASDrawingView

-(void)drawRect:(CGRect)rect{
    
    NSLog(@"drawRect: %@", NSStringFromCGRect(rect));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat boarderWidth = 15.f;
    CGFloat freeSpace = 20.f - boarderWidth;
    
    CGFloat boardMaxSize = MIN(CGRectGetWidth(rect) - 2*freeSpace - 2*boarderWidth,
                               CGRectGetHeight(rect) - 2*freeSpace - 2*boarderWidth);
    
    NSInteger cellSize = boardMaxSize / 8;
    NSInteger boardSize = cellSize * 8;
    
    CGRect boardRect = CGRectMake((CGRectGetWidth(rect) - boardSize) / 2,
                                  (CGRectGetHeight(rect) - boardSize) / 2,
                                  boardSize, boardSize);
    boardRect = CGRectIntegral(boardRect);
    CGRect boarderRect = CGRectInset(boardRect, -boarderWidth / 2, -boarderWidth / 2);
    //boarderRect = CGRectIntegral(boarderRect);
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (i % 2 != j % 2) {
                CGContextAddRect(context,CGRectMake(CGRectGetMinX(boardRect) + i * cellSize,
                                                    CGRectGetMinY(boardRect) + j * cellSize,
                                                    cellSize, cellSize));
            }
        }
    }
    

    //CGContextAddRect(context, boardRect);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    
    CGContextAddRect(context, boarderRect);
    CGContextSetStrokeColorWithColor(context, [UIColor brownColor].CGColor);
    CGContextSetLineWidth(context, boarderWidth);
    CGContextStrokePath(context);
    
    
    
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect square1 = CGRectMake(20, 20, 50, 50);
    CGRect square2 = CGRectMake(70, 70, 50, 50);
    CGRect square3 = CGRectMake(120, 120, 50, 50);
    
    // рисование квадратов
    CGContextAddRect(context, square1);
    CGContextAddRect(context, square2);
    CGContextAddRect(context, square3);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokePath(context);
    
    // рисование кругов
    CGContextAddEllipseInRect(context, square1);
    CGContextAddEllipseInRect(context, square2);
    CGContextAddEllipseInRect(context, square3);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
    
    // рисование линии
    CGContextMoveToPoint(context, CGRectGetMinX(square1), CGRectGetMaxY(square1));
    CGContextAddLineToPoint(context, CGRectGetMinX(square3), CGRectGetMaxY(square3));
    CGContextSetLineWidth(context, 10);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextStrokePath(context);
    
    // рисование линий из массива точек
    NSInteger numberofPoints = 5;
    CGPoint pointsForLines[numberofPoints];
    pointsForLines[0] = CGPointMake(200, 200);
    pointsForLines[1] = CGPointMake(200, 250);
    pointsForLines[2] = CGPointMake(250, 250);
    pointsForLines[3] = CGPointMake(250, 200);
    pointsForLines[4] = CGPointMake(200, 200);
    
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    
    // CGContextAddLines не работает
    //CGContextAddLines(context, &pointsForLines[numberofPoints], numberofPoints);

    
    // замена CGContextAddLines
    CGContextMoveToPoint (context, pointsForLines[0].x, pointsForLines[0].y);
    for (int k = 1; k < numberofPoints; k++) {
        CGContextAddLineToPoint (context, pointsForLines[k].x, pointsForLines[k].y);
    }
    CGContextStrokePath(context);
    
    // рисование дуги
    CGContextAddArc(context, CGRectGetMaxX(square1), CGRectGetMaxY(square1), CGRectGetWidth(square1), M_PI_2, M_PI, NO);
    CGContextSetLineWidth(context, 2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextStrokePath(context);
    
    // рисование дуги другой функцией
    CGContextMoveToPoint(context, CGRectGetMaxX(square3), CGRectGetMinY(square3));
    CGContextAddArcToPoint(context, CGRectGetMaxX(square2) + CGRectGetWidth(square2), CGRectGetMinY(square2),
                           CGRectGetMaxX(square2), CGRectGetMinY(square2), CGRectGetWidth(square2));
    CGContextStrokePath(context);

    // рисование текста
    NSString* text = @"Hello World!";
    UIFont* font = [UIFont systemFontOfSize:30.f];
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(5, 5);
    shadow.shadowColor = [UIColor grayColor];
    shadow.shadowBlurRadius = 2;
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor blackColor], NSForegroundColorAttributeName,
                                      font, NSFontAttributeName,
                                      shadow, NSShadowAttributeName,nil];
    
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    
    // могут быть проблемы с размытостью(блёр) текста из-за деления на дробные координаты
    //[text drawAtPoint:CGPointMake(CGRectGetMidX(square3) - textSize.width / 2, CGRectGetMidY(square3) - textSize.height / 2) textAttributes];
    
    CGRect textRect = CGRectMake(CGRectGetMidX(square3) - textSize.width / 2,
                                 CGRectGetMidY(square3) - textSize.height / 2,
                                 textSize.width, textSize.height);
    textRect = CGRectIntegral(textRect);
    [text drawInRect:textRect withAttributes:textAttributes];
    */
    
}

@end
