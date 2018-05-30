//
//  CacheManager.h
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (instancetype)sharedInstance;

- (void)resetCache;
- (NSString*)cacheDirectory;
- (void)objectForKey:(NSString *)key complitionHandler:(void(^)(NSData *data))completion;
- (void)setObject:(NSData *)data forKey:(NSString *)key;

@end
