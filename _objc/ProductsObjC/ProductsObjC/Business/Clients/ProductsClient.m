//
//  ProductsClient.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductsClient.h"
#import "Constants.h"

@interface ProductsClient ()

@end

@implementation ProductsClient

+ (instancetype)sharedInstance {
    static ProductsClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProductsClient alloc] init];
    });
    return sharedInstance;
}

- (void)getAllWithCompletionHandler:(void(^)(NSArray *array, NSError *error))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL_PRODUCT_LIST()]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *err;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        if (err) {
            completion(nil, error);
            return;
        }
        
        completion([Product getArrayFromJSON:json], nil);
        
    }] resume];
}

- (void)getProductForId:(NSString *)index withCompletionHandler:(void(^)(Product *product, NSError *error))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL_PRODUCT_FOR_ID(index)]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *err;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        if (err) {
            completion(nil, error);
            return;
        }
        
        completion([Product getFromJSON:json], nil);
        
    }] resume];
}

@end
