//
//  ProductCell.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+Network.h"

@interface ProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ProductCell

- (void)fillWithProduct:(Product *)product {
    self.nameLabel.text = product.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%ld", (long)product.price];
    [self.imageView loadImageFromStringURL:product.imageUrl];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = [UIImage imageNamed:@"placeholder"];
    
}

@end
