//
//  CustomNSLog.h
//  MRCtest
//
//  Created by Bondar Yaroslav on 11/07/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#ifndef CustomNSLog_h
#define CustomNSLog_h

/// https://stackoverflow.com/questions/7517252/clean-nslog-no-timestamp-and-program-name
#if __has_feature(objc_arc)
    #define NSLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
    #define NSLog(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);
#endif

#endif /* CustomNSLog_h */
