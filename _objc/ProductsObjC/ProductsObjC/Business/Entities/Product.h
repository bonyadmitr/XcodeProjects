//
//  Product.h
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCoraData+CoreDataClass.h"

@interface Product : NSObject

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger price;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *desc;

+ (Product *)getFromJSON:(NSDictionary *)JSON;
+ (NSArray *)getArrayFromJSON:(NSDictionary *)JSON;

+ (Product *)getFromCoreDataModel:(ProductCoraData *)cdProduct;
+ (NSArray<Product *> *)getArrayFromCoreDataModels:(NSArray *)cdProducts;

@end
