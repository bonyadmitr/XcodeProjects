//
//  ProductCell.h
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductCell : UICollectionViewCell

- (void)fillWithProduct:(Product *)product;

@end
