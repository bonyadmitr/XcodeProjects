//
//  ViewController.m
//  ClearAppTest
//
//  Created by zdaecqze zdaecq on 26.01.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

#pragma mark - LoadView

-(void) loadView{
    [super loadView];
    
    /*
    UIView* view = [[UIView alloc]
                    initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.bounds)- 40,
                                                     CGRectGetHeight(self.view.bounds) - 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 300, 50)];
    lable.text = @"Hello World";
    lable.font = [UIFont systemFontOfSize:40];
    lable.adjustsFontSizeToFitWidth = YES;
    lable.textColor = [UIColor whiteColor];
    [self.view addSubview:lable];
    */
    
    
    // инициализация таблицы
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.allowsSelection = NO;
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Section %d", section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Section %d, row %d", indexPath.section, indexPath.row];
    cell.detailTextLabel.text = @"Value";
    
    return cell;
}


@end
