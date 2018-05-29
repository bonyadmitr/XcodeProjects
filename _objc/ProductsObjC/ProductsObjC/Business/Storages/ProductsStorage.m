//
//  ProductsStorage.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ProductsStorage.h"
#import "CoraDataManager.h"
#import "ProductCoraData+CoreDataClass.h"

@implementation ProductsStorage

+ (instancetype)sharedInstance {
    static ProductsStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProductsStorage alloc] init];
    });
    return sharedInstance;
}

- (void)getAllWithPredicate:(NSPredicate *)predicate completionHandler:(void(^)(NSArray<ProductCoraData *> *array, NSError *error))completion {
    NSManagedObjectContext *context = [CoraDataManager.sharedInstance managedObjectContext];
    NSFetchRequest<ProductCoraData *> *fetchRequest = [ProductCoraData fetchRequest];
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    NSError *error;
    NSArray *resultArray = [context executeFetchRequest:fetchRequest error:&error];
    completion(resultArray, error);
}

- (void)createOrUpdateFromArray:(NSArray<Product *> *)array {
    NSManagedObjectContext *context = [CoraDataManager.sharedInstance managedObjectContext];
    
    [self getAllWithPredicate:nil completionHandler:^(NSArray *products, NSError *error) {
        for (NSManagedObject *product in products) {
            [context deleteObject:product];
        }
        
        for (Product *product in array) {
            ProductCoraData *cdProduct = [NSEntityDescription insertNewObjectForEntityForName:@"ProductCoraData" inManagedObjectContext:context];
            cdProduct.productId = product.productId;
            cdProduct.name = product.name;
            cdProduct.price = product.price;
            cdProduct.imageUrl = product.imageUrl;
            cdProduct.desc = product.desc;
        }
        [CoraDataManager.sharedInstance saveContext];
    }];
}

- (void)getProductForId:(NSString *)index completionHandler:(void(^)(ProductCoraData *product, NSError *error))completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId == %@", index];
    
    [self getAllWithPredicate:predicate completionHandler:^(NSArray *products, NSError *error) {
        
        ProductCoraData *cdProduct = products.firstObject;
        if (!cdProduct) {
            completion(nil, [NSError errorWithDomain:@"Internal error" code:1 userInfo:nil]);
        }
        completion(cdProduct, nil);
    }];
}

-(void)saveProduct:(Product *)product {
    [self getProductForId:product.productId completionHandler:^(ProductCoraData *cdProduct, NSError *error) {
        
        cdProduct.productId = product.productId;
        cdProduct.name = product.name;
        cdProduct.price = product.price;
        cdProduct.imageUrl = product.imageUrl;
        cdProduct.desc = product.desc;
        
        [CoraDataManager.sharedInstance saveContext];
    }];
}

@end
