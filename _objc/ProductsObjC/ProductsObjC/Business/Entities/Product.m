//
//  Product.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (Product *)getFromJSON:(NSDictionary *)JSON {
    Product *product = [[Product alloc] init];
    product.productId = JSON[@"product_id"];
    product.name = JSON[@"name"];
    product.price = [JSON[@"price"] integerValue];
    product.imageUrl = JSON[@"image"];
    product.desc = JSON[@"description"];
    return product;
}

+ (NSArray<Product *> *)getArrayFromJSON:(NSDictionary *)JSON {
    NSArray *array = JSON[@"products"];
    NSMutableArray<Product *> *result = [NSMutableArray array];
    
    for (NSDictionary *item in array) {
        Product *product = [Product getFromJSON:item];
        [result addObject:product];
    }
    
    return result;
}

+ (Product *)getFromCoreDataModel:(ProductCoraData *)cdProduct {
    Product *product = [[Product alloc] init];
    product.productId = cdProduct.productId;
    product.name = cdProduct.name;
    product.price = (NSInteger)cdProduct.price;
    product.imageUrl = cdProduct.imageUrl;
    product.desc = cdProduct.desc;
    return product;
}

+ (NSArray<Product *> *)getArrayFromCoreDataModels:(NSArray *)cdProducts {
    NSMutableArray<Product *> *result = [NSMutableArray array];
    for (ProductCoraData *item in cdProducts) {
        Product *product = [Product getFromCoreDataModel:item];
        [result addObject:product];
    }
    return result;
}

@end
