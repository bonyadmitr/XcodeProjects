//
//  UIImageView+Network.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "UIImageView+Network.h"
#import "CacheManager.h"
#import <objc/runtime.h>
#import "UIImage+Size.h"

@implementation UIImageView (Network)

- (void)loadImageFromStringURL:(NSString *)stringUrl {
    
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSURL *url = [NSURL URLWithString:stringUrl];
        NSString *key = url.absoluteString;
        
        [CacheManager.sharedInstance objectForKey:key complitionHandler:^(NSData *cachedData) {
            if (cachedData) {
                UIImage *loadedImage = [UIImage imageWithData:cachedData];
                UIImage *resizedImage = [loadedImage imageWithSize: size];
//                forceImageDecompression(loadedImage);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = resizedImage;
                    [self setNeedsLayout];
                });
                return;
            }
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (!data) {
                return;
            }
            UIImage *imageFromData = [UIImage imageWithData:data];
            UIImage *resizedImage = [imageFromData imageWithSize: size];
            
            [CacheManager.sharedInstance setObject:data forKey:key];
//            forceImageDecompression(imageFromData);
            if (imageFromData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = resizedImage;
                    [self setNeedsLayout];
                });
            }
        }];

    });
}

NS_INLINE void forceImageDecompression(UIImage *image)
{
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), 8, CGImageGetWidth(imageRef) * 4, colorSpace,kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    if (!context) { NSLog(@"Could not create context for image decompression"); return; }
    CGContextDrawImage(context, (CGRect){{0.0f, 0.0f}, {CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}}, imageRef);
    CFRelease(context);
}

@end
