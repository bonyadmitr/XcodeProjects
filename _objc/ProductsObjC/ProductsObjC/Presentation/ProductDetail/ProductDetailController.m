//
//  ProductDetailController.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductDetailController.h"
#import "ProductView.h"
#import "ProductsService.h"
#import "UIViewController+Extensions.h"

@interface ProductDetailController ()

@property (weak, nonatomic) IBOutlet ProductView *productView;

@end

@implementation ProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = self.product.name;
    [self.productView fillWithProduct:self.product];
    
    WEAK_SELF;
    [ProductsService.sharedInstance getProductForId:self.product.productId withCompletionHandler:^(Product *product, NSError *error) {
        STRONG_SELF;
        if (error) {
            [sself showError:error];
            NSLog(@"Error: %@", error);
            return;
        }
        
        [sself.productView fillWithProduct:product];
    }];
}

@end
