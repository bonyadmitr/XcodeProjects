//
//  UITableView+Extensions.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "UITableView+Extensions.h"

@implementation UITableView (Extensions)

- (__kindof UITableViewCell *)dequeueReusable:(Class)class forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(class) forIndexPath:indexPath];
}

@end
