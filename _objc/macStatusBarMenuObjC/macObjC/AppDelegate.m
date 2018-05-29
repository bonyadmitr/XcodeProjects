//
//  AppDelegate.m
//  macObjC
//
//  Created by Bondar Yaroslav on 02/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *menu;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

/// add key Application is agent (UIElement) to YES
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    /// NSSquareStatusItemLength
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.menu = self.menu;
    
    // The text that will be shown in the menu bar
    self.statusItem.title = @"qqq";
    
    // The image that will be shown in the menu bar, a 16x16 black png works best
//    _statusItem.image = [NSImage imageNamed:@"feedbin-logo"];
    
    // The highlighted image, use a white version of the normal image
//    _statusItem.alternateImage = [NSImage imageNamed:@"feedbin-logo-alt"];
    
    
    /// for backgoud app
//    [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


/// User clicks and holds on the application icon in the dock.
/// You can use outlet dockMenu of application in Storyboard instead of this method
//- (NSMenu *)applicationDockMenu:(NSApplication *)sende {
//    return self.menu;
//}


@end
