//
//  ProductsController.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductsController.h"
#import "UICollectionView+Extensions.h"
#import "ProductCell.h"
#import "Product.h"
#import "ProductDetailController.h"
#import "ProductsService.h"
#import "UIViewController+Extensions.h"

@interface ProductsController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<Product *> *products;

@end

@implementation ProductsController

static NSString * const productSegueId = @"product";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAK_SELF;
    [ProductsService.sharedInstance getAllWithCompletionHandler:^(NSArray *array, NSError *error) {
        STRONG_SELF;
        if (error) {
            [sself showError:error];
            NSLog(@"Error: %@", error);
            return;
        }
        sself.products = array;
        [sself.collectionView reloadData];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:productSegueId]) {
        ProductDetailController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        vc.product = self.products[indexPath.row];
    }
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [collectionView dequeueReusable:[ProductCell class] forIndexPath:indexPath];
    [cell fillWithProduct:self.products[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:productSegueId sender:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = UIScreen.mainScreen.bounds.size.width / 2 - 2;
    return CGSizeMake(width, 170);
}

@end
