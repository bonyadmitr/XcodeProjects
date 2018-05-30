//
//  ProductsObjCTests.m
//  ProductsObjCTests
//
//  Created by Bondar Yaroslav on 02/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CacheManager.h"

@interface ProductsObjCTests : XCTestCase

@end

@implementation ProductsObjCTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    [CacheManager.sharedInstance resetCache];
    [super tearDown];
}

- (void)testCacheManagerSet {
    /// Given
    NSString *key = @"someKey";
    NSData *testData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    /// When
    [CacheManager.sharedInstance setObject:testData forKey:key];
    
    /// Then
    XCTestExpectation *expectation = [self expectationWithDescription:@"async call"];
    [CacheManager.sharedInstance objectForKey:key complitionHandler:^(NSData *data) {
        XCTAssertEqualObjects(testData, data);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

- (void)testCacheManagerReset {
    /// Given
    NSString *key = @"someKey";
    NSData *testData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    /// When
    [CacheManager.sharedInstance setObject:testData forKey:key];
    [CacheManager.sharedInstance resetCache];
    
    /// Then
    XCTestExpectation *expectation = [self expectationWithDescription:@"async call"];
    [CacheManager.sharedInstance objectForKey:key complitionHandler:^(NSData *data) {
        XCTAssertNil(data);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:1];
}

@end
