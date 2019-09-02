//
//  JJMenuPopulator.h
//  Nibless
//
//  Created by Jeffrey Johnson on 6/3/07.
//  Copyright 2007 Lap Cat Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JJMenuPopulator : NSObject {}

+(void) populateMainMenu;

+(void) populateApplicationMenu:(NSMenu *)menu;
+(void) populateDebugMenu:(NSMenu *)menu;
+(void) populateEditMenu:(NSMenu *)menu;
+(void) populateFileMenu:(NSMenu *)menu;
+(void) populateFindMenu:(NSMenu *)menu;
+(void) populateHelpMenu:(NSMenu *)menu;
+(void) populateSpellingMenu:(NSMenu *)menu;
+(void) populateViewMenu:(NSMenu *)menu;
+(void) populateWindowMenu:(NSMenu *)menu;

@end
