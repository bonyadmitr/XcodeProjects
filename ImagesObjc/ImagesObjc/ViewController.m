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


//Helper methods
@implementation NSIndexSet (Convenience)
- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end

@implementation UICollectionView (Convenience)
- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
@end

@interface ViewController () <UICollectionViewDelegateFlowLayout> //UICollectionViewDataSourcePrefetching

@property (strong, nonatomic) PHFetchResult *fetchResult;
@property (strong, nonatomic) PHCachingImageManager *cachingManager;
@property (strong, nonatomic) PHImageRequestOptions *requestOptions;

@property CGSize itemSize;
@property CGRect previousPreheatRect;

@end

@implementation ViewController

static NSString *cellIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    assert(self.collectionView);
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    //self.collectionView.prefetchDataSource = self;
    
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
                //self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                //self.requestOptions.networkAccessAllowed = NO;
                //self.requestOptions.version = PHImageRequestOptionsVersionCurrent;
                //self.requestOptions.synchronous = NO;
                
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
//    CGFloat desiredItemWidth = 100;
    BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    CGFloat viewWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat columns = isIpad ? 6 : 4;//fmax(floor(viewWidth / desiredItemWidth), 4);
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
    
    
//    if (photoCell.imageRequestID != 0 && ![photoCell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
//        PHImageRequestID imageRequestID = photoCell.imageRequestID;
////        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//            [self.cachingManager cancelImageRequest:imageRequestID];
////        });
//    }
    
    photoCell.representedAssetIdentifier = asset.localIdentifier;
    
    photoCell.imageRequestID = [self.cachingManager requestImageForAsset:asset
                                                              targetSize:self.itemSize
                                                             contentMode:PHImageContentModeAspectFill
                                                                 options:nil
                                                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
                                {
                                    if ([photoCell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                        photoCell.imageView.image = result;
                                        photoCell.imageRequestID = 0;
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

//-(void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
//    NSArray *assetsToStartCaching = [self assetsAtIndexPaths:indexPaths];
//    [self.cachingManager startCachingImagesForAssets:assetsToStartCaching
//                                          targetSize:self.itemSize
//                                         contentMode:PHImageContentModeAspectFill
//                                             options:nil];
//
//}
//-(void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
//        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:indexPaths];
//        [self.cachingManager stopCachingImagesForAssets:assetsToStopCaching
//                                             targetSize:self.itemSize
//                                            contentMode:PHImageContentModeAspectFill
//                                                options:nil];
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self updateCachedAssets];
//}


#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [self.cachingManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        [self.cachingManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:self.itemSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.cachingManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:self.itemSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.fetchResult[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}

@end
