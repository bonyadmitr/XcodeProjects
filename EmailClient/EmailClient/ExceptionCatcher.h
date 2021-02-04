//
//  ExceptionCatcher.h
//  EmailClient
//
//  Created by Yaroslav Bondr on 01.02.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// source https://github.com/sindresorhus/ExceptionCatcher
@interface ExceptionCatcher: NSObject
+ (BOOL)catchException:(__attribute__((noescape)) void(^)(void))tryBlock error:(__autoreleasing NSError **)error;
@end


NS_ASSUME_NONNULL_END
