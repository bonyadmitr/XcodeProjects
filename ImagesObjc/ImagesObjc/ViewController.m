//
//  ViewController.m
//  ImagesObjc
//
//  Created by Bondar Yaroslav on 12/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"
@import Photos;

@interface ViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) PHFetchResult *fetchResult;
@property (strong, nonatomic) PHCachingImageManager *cachingManager;
@property (strong, nonatomic) PHImageRequestOptions *requestOptions;

@property CGSize itemSize;

@end

@implementation ViewController

static NSString *cellIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    assert(self.collectionView);
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:
                break;
            case PHAuthorizationStatusRestricted:
                break;
            case PHAuthorizationStatusDenied:
                break;
            case PHAuthorizationStatusAuthorized:
                self.cachingManager = [[PHCachingImageManager alloc] init];
                self.cachingManager.allowsCachingHighQualityImages = NO;
                
                self.requestOptions = [[PHImageRequestOptions alloc] init];
                self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                self.requestOptions.networkAccessAllowed = NO;
                self.requestOptions.version = PHImageRequestOptionsVersionCurrent;
                self.requestOptions.synchronous = NO;
                
                [self performFetch];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.collectionView reloadData];
                });
                
                break;
        }
    }];
    
//                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                    //Background Thread
//                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                        //Run UI Updates
//                    });
//                });
}

- (void)updateCellSize {
    CGFloat desiredItemWidth = 100;
    CGFloat viewWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat columns = fmax(floor(viewWidth / desiredItemWidth), 4);
    CGFloat padding = 1;
    CGFloat itemWidth = floor((viewWidth - (columns - 1) * padding) / columns);
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (layout) {
        layout.itemSize = itemSize;
        layout.minimumInteritemSpacing = padding;
        layout.minimumLineSpacing = padding;
    }
    
    CGFloat scale = 2; //UIScreen.mainScreen.scale
    self.itemSize = CGSizeMake(itemSize.width * scale, itemSize.height * scale);
    
//    [self.cachingManager startCachingImagesForAssets:self.fetchResult targetSize:self.itemSize contentMode:PHImageContentModeAspectFill options:nil];
}

-(void)performFetch {
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    self.fetchResult = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    assert(self.fetchResult);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateCellSize];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateCellSize];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *photoCell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath: indexPath];
    PHAsset *asset = [self.fetchResult objectAtIndex:indexPath.item];
    photoCell.representedAssetIdentifier = asset.localIdentifier;
    
    [self.cachingManager requestImageForAsset:asset
                                   targetSize:self.itemSize
                                  contentMode:PHImageContentModeAspectFill
                                      options:self.requestOptions
                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         if ([photoCell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
             photoCell.imageView.image = result;
         }
     }];
    
    return photoCell;
}

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath: indexPath];
//}
//
//-(void)collectionView:(UICollectionView *)collectionView
//      willDisplayCell:(UICollectionViewCell *)cell
//   forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    PhotoCell *photoCell = (PhotoCell *)cell;
//    if (!photoCell) {
//        assert(photoCell)
//        return;
//    }
//
//    PHAsset *asset = [self.fetchResult objectAtIndex:indexPath.item];
//    if (!asset) {
//        assert(photoCell)
//        return;
//    }
//
//    photoCell.representedAssetIdentifier = asset.localIdentifier;
//
//    [self.cachingManager requestImageForAsset:asset
//                                   targetSize:self.itemSize
//                                  contentMode:PHImageContentModeAspectFill
//                                      options:self.requestOptions
//                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
//     {
//         if ([photoCell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
//             photoCell.imageView.image = result;
//         }
//
//    }];
//}

@end
