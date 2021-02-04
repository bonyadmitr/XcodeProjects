//
//  ExceptionCatcher.m
//  EmailClient
//
//  Created by Yaroslav Bondr on 01.02.2021.
//

#import "ExceptionCatcher.h"

@implementation ExceptionCatcher

+ (BOOL)catchException:(__attribute__((noescape)) void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    } @catch (NSException *exception) {
        /// old
        //*error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:@{
            NSUnderlyingErrorKey: exception,
            NSLocalizedDescriptionKey: exception.reason,
            @"CallStackSymbols": exception.callStackSymbols
        }];

        return NO;
    }
}

@end
