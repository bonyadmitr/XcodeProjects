//
//  PostsStorage.h
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/Promise.h>

@interface PostsStorage : NSObject

+ (instancetype) sharedInstance;

- (PMKPromise *) getAll;
- (PMKPromise *) createOrUpdateFrom: (NSArray *) array;

@end
