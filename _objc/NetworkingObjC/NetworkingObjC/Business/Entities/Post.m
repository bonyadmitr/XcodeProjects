//
//  Post.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"title": @"title",
             @"id": @"id",
             @"userId": @"userId",
             @"body": @"body"
    };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             @"title": @"title",
             @"id": @"id",
             @"userId": @"userId",
             @"body": @"body"
    };
}

@end
