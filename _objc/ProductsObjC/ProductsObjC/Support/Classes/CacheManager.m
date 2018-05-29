//
//  CacheManager.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "CacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface CacheManager ()
@property (strong, nonatomic) NSCache *cache;
@end

@implementation CacheManager

static NSTimeInterval cacheTime = 604800;

+ (instancetype)sharedInstance {
    static CacheManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheManager alloc] init];
        sharedInstance.cache = [[NSCache alloc] init];
    });
    return sharedInstance;
}

- (void)resetCache {
    [[NSFileManager defaultManager] removeItemAtPath:[self cacheDirectory] error:nil];
    [self.cache removeAllObjects];
}

- (NSString *)cacheDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"CacheManager"];
    return cacheDirectory;
}

- (void)objectForKey:(NSString *)key complitionHandler:(void(^)(NSData *data))completion {
    NSString *realKey = [self getMD5HashForString:key];
    NSData *cachedObject = [self.cache objectForKey:realKey];
    if (cachedObject) {
        completion(cachedObject);
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:realKey];
    
    if ([fileManager fileExistsAtPath:filename]) {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            [self.cache setObject:data forKey:realKey];
            completion(data);
            return;
        }
    }
    completion(nil);
}

- (void)setObject:(NSData *)data forKey:(NSString *)key {
    NSString *realKey = [self getMD5HashForString:key];
    [self.cache setObject:data forKey:realKey];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:realKey];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    [data writeToFile:filename options:NSDataWritingAtomic error:nil];
}

/// can be created NSString extension
- (NSString *)getMD5HashForString:(NSString *)str {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [str UTF8String], (CC_LONG)[str length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

@end
