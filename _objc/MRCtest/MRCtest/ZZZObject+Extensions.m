//
//  ZZZObject+Extensions.m
//  MRCtest
//
//  Created by Bondar Yaroslav on 10/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ZZZObject+Extensions.h"

@implementation ZZZObject (Extensions)

- (void)print {
    NSLog(@"publicVar %d", publicVar);
    NSLog(@"protectedVar %d", protectedVar);
    NSLog(@"privateVar %d", privateVar);
    NSLog(@"packageVar %d", packageVar);
}

@end
