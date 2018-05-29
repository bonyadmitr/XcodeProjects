//
//  ProductsStorage.h
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface ProductsStorage : NSObject

+ (instancetype) sharedInstance;

- (void)getAllWithPredicate:(NSPredicate *)predicate completionHandler:(void(^)(NSArray<ProductCoraData *> *array, NSError *error))completion;
- (void)createOrUpdateFromArray:(NSArray<Product *> *)array;

- (void)getProductForId:(NSString *)index completionHandler:(void(^)(ProductCoraData *product, NSError *error))completion;
-(void)saveProduct:(Product *)product;

@end
