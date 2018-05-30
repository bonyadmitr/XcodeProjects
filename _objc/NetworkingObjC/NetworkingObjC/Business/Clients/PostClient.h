//
//  PostClient.h
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/Promise.h>

@interface PostClient : NSObject

+ (instancetype) sharedInstance;

- (PMKPromise *) getAll;

@end
