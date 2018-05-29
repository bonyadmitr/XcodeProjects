//
//  PostClient.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "PostClient.h"
#import <AFNetworking.h>
#import "Constants.h"

@interface PostClient ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation PostClient

+ (instancetype)sharedInstance {
    static PostClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PostClient alloc] init];
        sharedInstance.manager = [AFHTTPSessionManager manager];
    });
    return sharedInstance;
}

- (PMKPromise *)getAll {
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        
        [self.manager GET:POST_URL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            if (![responseObject isKindOfClass:[NSArray class]]) {
                #warning todo errors handler
                NSError *error = [[NSError alloc] initWithDomain:@"" code:1 userInfo:@{}];
                resolve(error);
                return;
            }
            resolve(responseObject);
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            resolve(error);
        }];
        
    }];
}

@end
