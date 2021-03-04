#import <UIKit/UIKit.h>

/// can be used without interface and UIStatusBarManager+StatusBarTap.h file
/// also don't need to create PROJECT_NAME-Bridging-Header.h
/// insipred https://stackoverflow.com/a/59897714/5893286
/// UIKit headers https://developer.limneos.net/index.php?ios=13.1.3&framework=UIKitCore.framework&header=UIStatusBarManager.h
//TODO: maybe it is better to swizzle it
//TODO: check https://github.com/DGh0st/FLEXall/blob/master/Tweak.xm#L179
//@implementation UIStatusBarManager (StatusBarTap)
//
//-(void)handleTapAction:(id)arg1 {
//    //NSLog(@"%@", arg1); //UIStatusBarTapAction
//    [NSNotificationCenter.defaultCenter postNotificationName:@"StatusBarTap" object:nil];
//}
//
//@end
