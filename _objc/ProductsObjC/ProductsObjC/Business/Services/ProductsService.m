//
//  ProductsService.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductsService.h"
#import "ProductsStorage.h"
#import "ProductsClient.h"

//@interface ProductsService ()
//
//@property (strong, nonatomic) AFHTTPSessionManager *manager;
//
//@end


@implementation ProductsService

+ (instancetype)sharedInstance {
    static ProductsService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProductsService alloc] init];
    });
    return sharedInstance;
}

- (void)getAllWithCompletionHandler:(void(^)(NSArray *array, NSError *error))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ProductsStorage.sharedInstance getAllWithPredicate:nil completionHandler:^(NSArray *array, NSError *error) {
            NSArray *products = [Product getArrayFromCoreDataModels:array];
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(products, error);
            });
            
            [ProductsClient.sharedInstance getAllWithCompletionHandler:^(NSArray *array, NSError *error) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(array, error);
                });
                [ProductsStorage.sharedInstance createOrUpdateFromArray:array];
            }];
        }];
        
    });
}

- (void)getProductForId:(NSString *)index withCompletionHandler:(void(^)(Product *product, NSError *error))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ProductsStorage.sharedInstance getProductForId:index completionHandler:^(ProductCoraData *cdProduct, NSError *error) {
            
            Product *product = [Product getFromCoreDataModel:cdProduct];
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(product, error);
            });
            
            [ProductsClient.sharedInstance getProductForId:index withCompletionHandler:^(Product *product, NSError *error) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(product, error);
                });
                
                [ProductsStorage.sharedInstance saveProduct:product];
                
            }];
            
        }];
        
    });
}

@end
