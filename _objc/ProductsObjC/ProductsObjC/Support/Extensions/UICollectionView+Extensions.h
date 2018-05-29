//
//  UICollectionView+Extensions.h
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Extensions)

- (__kindof UICollectionViewCell *)dequeueReusable:(Class)class forIndexPath:(NSIndexPath *)indexPath;

@end
