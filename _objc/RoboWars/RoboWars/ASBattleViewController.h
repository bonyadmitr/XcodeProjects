//
//  ASViewController.h
//  RoboWars
//
//  Created by Oleksii Skutarenko on 13.10.13.
//  Copyright (c) 2013 Alex Skutarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASBattleFieldView;

@interface ASBattleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet ASBattleFieldView* battleView;
@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (IBAction) actionNewGame:(id)sender;
- (IBAction) actionMove:(id)sender;


@end
