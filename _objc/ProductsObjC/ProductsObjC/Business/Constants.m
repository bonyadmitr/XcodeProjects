//
//  Constants.m
//  ProductsObjC
//
//  Created by Bondar Yaroslav on 30/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "Constants.h"

#ifdef DEBUG
#else
#endif

NSString * const URL_BASE = @"https://s3-eu-west-1.amazonaws.com/developer-application-test/cart";

NSString * const URL_PRODUCT_LIST() {
    return [NSString stringWithFormat:@"%@/list", URL_BASE];
}

NSString * URL_PRODUCT_FOR_ID(NSString *index) {
    return [NSString stringWithFormat:@"%@/%@/detail", URL_BASE, index];
}
