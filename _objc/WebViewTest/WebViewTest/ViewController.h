//
//  ViewController.h
//  WebViewTest
//
//  Created by zdaecqze zdaecq on 11.02.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonWebBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonWebForward;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabButtonCustomTest;


- (IBAction)actionWebBack:(UIBarButtonItem *)sender;
- (IBAction)actionWebForward:(UIBarButtonItem *)sender;
- (IBAction)actionWebRefresh:(UIBarButtonItem *)sender;
@end

