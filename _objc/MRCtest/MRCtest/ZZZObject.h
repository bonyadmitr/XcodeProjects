//
//  ZZZObject.h
//  MRCtest
//
//  Created by Bondar Yaroslav on 10/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZZObject : NSObject {
    
    /// https://stackoverflow.com/a/29526022/5893286
    /// In reality there is no limitation and you can access all methods and properties using Obj-C runtime
    
    /// ivar or Instance Variable
        BOOL defaultVar; /// default is @protected in @interface
    @public /// accessible from anywhere
        BOOL publicVar;
    @protected /// to subclasses
        BOOL protectedVar;
    @private /// only to the class
        BOOL privateVar;
    @package /// package only aka Framework or Library
        BOOL packageVar;
}

+ (instancetype)sharedManager;

/// declares the accessor, mutator methods and ivar _synthesizeVar
@property (assign, nonatomic, readonly) BOOL synthesizeVar;
@property (retain, nonatomic) NSString *name;

- (NSString *)getSomeStringAutorelease;
- (NSString *)getSomeStringRetain;
- (NSString *)getSomeStringNormal;

@end
