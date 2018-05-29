//
//  ProductView.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 01/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductView.h"
#import "UIImageView+Network.h"

@interface ProductView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation ProductView

- (void)fillWithProduct:(Product *)product {
    [self setNeedsLayout];
    self.nameLabel.text = product.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%ld", (long)product.price];
    self.descLabel.text = product.desc;
    [self.imageView loadImageFromStringURL:product.imageUrl];
}

@end
