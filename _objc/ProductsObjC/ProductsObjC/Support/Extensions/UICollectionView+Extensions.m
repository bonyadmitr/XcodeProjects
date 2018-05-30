//
//  UICollectionView+Extensions.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "UICollectionView+Extensions.h"

@implementation UICollectionView (Extensions)

- (__kindof UICollectionViewCell *)dequeueReusable:(Class)class forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(class) forIndexPath:indexPath];
}

@end
