//
//  ProductsService.h
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface ProductsService : NSObject

+ (instancetype)sharedInstance;

- (void)getAllWithCompletionHandler:(void(^)(NSArray *array, NSError *error))completion;
- (void)getProductForId:(NSString *)index withCompletionHandler:(void(^)(Product *product, NSError *error))completion;

@end
