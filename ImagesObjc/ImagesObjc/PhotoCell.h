//
//  PhotoCell.h
//  ImagesObjc
//
//  Created by Bondar Yaroslav on 12/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *representedAssetIdentifier;
@property (assign, nonatomic) PHImageRequestID imageRequestID;

@end

NS_ASSUME_NONNULL_END
