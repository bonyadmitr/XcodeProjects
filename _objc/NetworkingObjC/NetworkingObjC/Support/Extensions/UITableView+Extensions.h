//
//  UITableView+Extensions.h
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extensions)

- (__kindof UITableViewCell *)dequeueReusable:(Class)class forIndexPath:(NSIndexPath *)indexPath;

@end
