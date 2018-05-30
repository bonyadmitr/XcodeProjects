//
//  ViewController.h
//  WorkCalendar
//
//  Created by zdaecqze zdaecq on 15.03.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)actionNextMonth:(UIButton *)sender;
- (IBAction)actionPreviousMonth:(UIButton *)sender;
- (IBAction)actionCurrentMonth:(UIButton *)sender;

@end