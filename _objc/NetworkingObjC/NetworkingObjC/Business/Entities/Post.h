//
//  Post.h
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <PromiseKit/Promise.h>
 
@interface Post : RLMObject

@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;

@end

RLM_ARRAY_TYPE(Post)
