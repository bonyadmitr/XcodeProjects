//
//  ZZZObject.m
//  MRCtest
//
//  Created by Bondar Yaroslav on 10/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "ZZZObject.h"

/// Class Extension
@interface ZZZObject () {
    /// not working, @private for all @...
        BOOL defaultVar2;
    @public
        BOOL publicVar2;
    @protected
        BOOL protectedVar2;
    @private
        BOOL privateVar2;
    @package
        BOOL packageVar2;
}

@end

@implementation ZZZObject {
    /// not working, @private for all @...
        BOOL defaultVar3;
    @public
        BOOL publicVar3;
    @protected
        BOOL protectedVar3;
    @private
        BOOL privateVar3;
    @package
        BOOL packageVar3;
}

/// https://stackoverflow.com/questions/2159725/difference-between-interface-declaration-and-property-declaration
/// create setter and getter (accessor and mutator) like
/// - (BOOL)synthesizeVar;
/// - (void)setSynthesizeVar:(BOOL)synthesizeVar
/// today @synthesize is not needed anymore
@synthesize synthesizeVar = _synthesizeVar;
/// or can be used @synthesize synthesizeVar;
/// bcx getter will be called with self.synthesizeVar



- (instancetype)init {
    self = [super init];
    if (self) { /// or can be used: if (self = [super init])
        /// use iVars in inits. Apple recommends it
        _name = @"Kate";
        NSLog(@"from init %@", _name);
        _synthesizeVar = YES;
        privateVar = YES;
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}


- (NSString *)getSomeStringAutorelease {
    return [[[NSString alloc] initWithFormat:@"qwerty"] autorelease];
}

/// warning from Analyze
- (NSString *)getSomeStringRetain {
    return [[NSString alloc] initWithFormat:@"qwerty"];
}

- (NSString *)getSomeStringNormal {
    return [NSString stringWithFormat:@"qwerty"];
}





#pragma mark - Singletons

/// ARC
/// thread safe GCD
//+ (instancetype)sharedInstance {
//    static ZZZObject *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[ZZZObject alloc] init];
//        /// Do any other initialisation stuff here
//        /// Or use init for that
//    });
//    return sharedInstance;
//}

/// thread safe Non-GCD
//+ (instancetype)sharedManager2 {
//    static ZZZObject *sharedMyManager2 = nil;
//    @synchronized(self) {
//        if (sharedMyManager2 == nil)
//            sharedMyManager2 = [[self alloc] init];
//    }
//    return sharedMyManager2;
//}


#pragma mark MRC Singleton Methods
/// http://www.galloway.me.uk/tutorials/singleton-classes/
/// or use SYNTHESIZE_SINGLETON_FOR_CLASS(ZZZObject) from SynthesizeSingleton.h

static ZZZObject *sharedMyManager = nil;

+ (instancetype)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}
+ (instancetype)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}
- (instancetype)retain {
    return self;
}
- (NSUInteger)retainCount {
    return NSUIntegerMax; //denotes an object that cannot be released
}
- (oneway void)release {
    // never release
}
- (instancetype)autorelease {
    return self;
}

@end
