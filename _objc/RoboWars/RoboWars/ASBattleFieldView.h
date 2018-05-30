//
//  ASBattleFieldView.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ASBattleFieldDataSource;


@interface ASBattleFieldView : UIView

@property (weak, nonatomic) id <ASBattleFieldDataSource> dataSource;

- (void) reloadData;

- (void) animateShotTo:(CGPoint) coordinate fromRect:(CGRect) rect;

@end


@protocol ASBattleFieldDataSource <NSObject>

@required

- (CGSize) sizeForBattleField:(ASBattleFieldView*) battleField;

- (NSInteger) numberOfRobotsOnBattleField:(ASBattleFieldView*) battleField;

- (CGRect) battleField:(ASBattleFieldView*) battleField rectForRobotAtIndex:(NSInteger) index;

- (NSInteger) numberOfShotsOnBattleField:(ASBattleFieldView*) battleField;

- (CGPoint) battleField:(ASBattleFieldView*) battleField shotCoordinateAtIndex:(NSInteger) index;

- (NSString*) battleField:(ASBattleFieldView*) battleField nameForRobotAtIndex:(NSInteger) index;

@optional

- (UIColor*) battleField:(ASBattleFieldView*) battleField colorForRobotAtIndex:(NSInteger) index;

@end