//
//  PostsStorage.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "PostsStorage.h"
#import "Post.h"
#import <Realm+JSON/RLMObject+JSON.h>
#import "RLMResults+ToArray.h"

@implementation PostsStorage

+ (instancetype)sharedInstance {
    static PostsStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PostsStorage alloc] init];
    });
    return sharedInstance;
}

- (PMKPromise *)createOrUpdateFrom:(NSArray *)array {
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [RLMRealm.defaultRealm transactionWithBlock:^{
            NSArray *posts = [Post createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONArray:array];
            resolve(posts);
        }];
    }];
}

- (PMKPromise *)getAll {
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        resolve([[Post allObjects] toArray]);
    }];
}

@end
