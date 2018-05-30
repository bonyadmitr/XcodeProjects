//
//  XXXChild.m
//  MRCtest
//
//  Created by Bondar Yaroslav on 10/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "XXXChild.h"
#import "SynthesizeSingleton.h"

@implementation XXXChild

SYNTHESIZE_SINGLETON_FOR_CLASS(XXXChild)

-(void)print {
    NSLog(@"XXXChild %d", protectedVar);
    NSLog(@"XXXChild privateVar3 %@", [self valueForKey:@"privateVar3"]);
    
    
    [super print];
}

@end
