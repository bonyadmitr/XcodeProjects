//
//  ImageTestViewController.m
//  WebViewTest
//
//  Created by zdaecqze zdaecq on 12.02.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

#import "ImageTestViewController.h"

@implementation ImageTestViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    //self.scrollView.minimumZoomScale = 0.5;
    //self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    //self.scrollView.delegate = self;
    
}


#pragma mark - UIScrollViewDelegate


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
