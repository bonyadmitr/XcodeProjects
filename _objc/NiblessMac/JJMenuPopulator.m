//
//  JJMenuPopulator.m
//  Nibless
//
//  Created by Jeffrey Johnson on 6/3/07.
//  Copyright 2007 Lap Cat Software. All rights reserved.
//

#import "JJMenuPopulator.h"
#import "JJApplicationDelegate.h"

@implementation JJMenuPopulator

#pragma mark JJMenuPopulator

+(void) populateMainMenu {
	NSMenu * mainMenu = [[[NSMenu alloc] initWithTitle:@"MainMenu"] autorelease];
	
	NSMenuItem * item;
	NSMenu * submenu;
	
	// The titles of the menu items are for identification purposes only and shouldn't be localized.
	// The strings in the menu bar come from the submenu titles,
	// except for the application menu, whose title is ignored at runtime.
	item = [mainMenu addItemWithTitle:@"Apple" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:@"Apple"] autorelease];
	[NSApp performSelector:@selector(setAppleMenu:) withObject:submenu];
	[self populateApplicationMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];
	
	item = [mainMenu addItemWithTitle:@"File" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"File", @"The File menu")] autorelease];
	[self populateFileMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];
	
	item = [mainMenu addItemWithTitle:@"Edit" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"Edit", @"The Edit menu")] autorelease];
	[self populateEditMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];
	
	/*item = [mainMenu addItemWithTitle:@"View" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"View", @"The View menu")] autorelease];
	[self populateViewMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];*/
	
	item = [mainMenu addItemWithTitle:@"Window" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"Window", @"The Window menu")] autorelease];
	[self populateWindowMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];
	[NSApp setWindowsMenu:submenu];
	
	item = [mainMenu addItemWithTitle:@"Help" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"Help", @"The Help menu")] autorelease];
	[self populateHelpMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];
	
	/*item = [mainMenu addItemWithTitle:@"Debug" action:NULL keyEquivalent:@""];
	submenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"Debug", @"The Debug menu")] autorelease];
	[self populateDebugMenu:submenu];
	[mainMenu setSubmenu:submenu forItem:item];*/
	
	[NSApp setMainMenu:mainMenu];
}

+(void) populateApplicationMenu:(NSMenu *)menu {
	NSString * applicationName = [[NSApp delegate] applicationName];
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"About", nil), applicationName]
						   action:@selector(orderFrontStandardAboutPanel:)
					keyEquivalent:@""];
	[item setTarget:NSApp];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Preferences...", nil)
						   action:NULL
					keyEquivalent:@","];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Services", nil)
						   action:NULL
					keyEquivalent:@""];
	NSMenu * servicesMenu = [[[NSMenu alloc] initWithTitle:@"Services"] autorelease];
	[menu setSubmenu:servicesMenu forItem:item];
	[NSApp setServicesMenu:servicesMenu];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Hide", nil), applicationName]
						   action:@selector(hide:)
					keyEquivalent:@"h"];
	[item setTarget:NSApp];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Hide Others", nil)
						   action:@selector(hideOtherApplications:)
					keyEquivalent:@"h"];
	[item setKeyEquivalentModifierMask:NSCommandKeyMask | NSAlternateKeyMask];
	[item setTarget:NSApp];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Show All", nil)
						   action:@selector(unhideAllApplications:)
					keyEquivalent:@""];
	[item setTarget:NSApp];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Quit", nil), applicationName]
						   action:@selector(terminate:)
					keyEquivalent:@"q"];
	[item setTarget:NSApp];
}

+(void) populateDebugMenu:(NSMenu *)menu {
	// TODO
}

+(void) populateEditMenu:(NSMenu *)menu {
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Undo", nil)
						   action:@selector(undo:)
					keyEquivalent:@"z"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Redo", nil)
						   action:@selector(redo:)
					keyEquivalent:@"Z"];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Cut", nil)
						   action:@selector(cut:)
					keyEquivalent:@"x"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Copy", nil)
						   action:@selector(copy:)
					keyEquivalent:@"c"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Paste", nil)
						   action:@selector(paste:)
					keyEquivalent:@"v"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Paste and Match Style", nil)
						   action:@selector(pasteAsPlainText:)
					keyEquivalent:@"V"];
	[item setKeyEquivalentModifierMask:NSCommandKeyMask | NSAlternateKeyMask];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Delete", nil)
						   action:@selector(delete:)
					keyEquivalent:@""];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Select All", nil)
						   action:@selector(selectAll:)
					keyEquivalent:@"a"];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Find", nil)
						   action:NULL
					keyEquivalent:@""];
	NSMenu * findMenu = [[[NSMenu alloc] initWithTitle:@"Find"] autorelease];
	[self populateFindMenu:findMenu];
	[menu setSubmenu:findMenu forItem:item];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Spelling", nil)
						   action:NULL
					keyEquivalent:@""];
	NSMenu * spellingMenu = [[[NSMenu alloc] initWithTitle:@"Spelling"] autorelease];
	[self populateSpellingMenu:spellingMenu];
	[menu setSubmenu:spellingMenu forItem:item];
}

+(void) populateFileMenu:(NSMenu *)menu {
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:NSLocalizedString(@"New", nil)
						   action:NULL
					keyEquivalent:@"n"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Open...", nil)
						   action:NULL
					keyEquivalent:@"o"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Open Recent", nil)
						   action:NULL
					keyEquivalent:@""];
	NSMenu * openRecentMenu = [[[NSMenu alloc] initWithTitle:@"Open Recent"] autorelease];
	[openRecentMenu performSelector:@selector(_setMenuName:) withObject:@"NSRecentDocumentsMenu"];
	[menu setSubmenu:openRecentMenu forItem:item];
	
	item = [openRecentMenu addItemWithTitle:NSLocalizedString(@"Clear Menu", nil)
									 action:@selector(clearRecentDocuments:)
							  keyEquivalent:@""];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Close", nil)
						   action:@selector(performClose:)
					keyEquivalent:@"w"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Save", nil)
						   action:NULL
					keyEquivalent:@"s"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Save As...", nil)
						   action:NULL
					keyEquivalent:@"S"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Revert", nil)
						   action:NULL
					keyEquivalent:@""];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Page Setup...", nil)
						   action:@selector(runPageLayout:)
					keyEquivalent:@"P"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Print...", nil)
						   action:@selector(print:)
					keyEquivalent:@"p"];
}

+(void) populateFindMenu:(NSMenu *)menu {
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Find...", nil)
						   action:@selector(performFindPanelAction:)
					keyEquivalent:@"f"];
	[item setTag:NSFindPanelActionShowFindPanel];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Find Next", nil)
						   action:@selector(performFindPanelAction:)
					keyEquivalent:@"g"];
	[item setTag:NSFindPanelActionNext];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Find Previous", nil)
						   action:@selector(performFindPanelAction:)
					keyEquivalent:@"G"];
	[item setTag:NSFindPanelActionPrevious];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Use Selection for Find", nil)
						   action:@selector(performFindPanelAction:)
					keyEquivalent:@"e"];
	[item setTag:NSFindPanelActionSetFindString];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Jump to Selection", nil)
						   action:@selector(centerSelectionInVisibleArea:)
					keyEquivalent:@"j"];
}

+(void) populateHelpMenu:(NSMenu *)menu {
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:[NSString stringWithFormat:@"%@ %@", [[NSApp delegate] applicationName], NSLocalizedString(@"Help", nil)]
						   action:@selector(showHelp:)
					keyEquivalent:@"?"];
	[item setTarget:NSApp];
}

+(void) populateSpellingMenu:(NSMenu *)menu {
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Spelling...", nil)
						   action:@selector(showGuessPanel:)
					keyEquivalent:@":"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Check Spelling", nil)
						   action:@selector(checkSpelling:)
					keyEquivalent:@";"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Check Spelling as You Type", nil)
						   action:@selector(toggleContinuousSpellChecking:)
					keyEquivalent:@""];
}

+(void) populateViewMenu:(NSMenu *)menu {
	// TODO
}

+(void) populateWindowMenu:(NSMenu *)menu {
	NSMenuItem * item;
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Minimize", nil)
						   action:@selector(performMinimize:)
					keyEquivalent:@"m"];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Zoom", nil)
						   action:@selector(performZoom:)
					keyEquivalent:@""];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	item = [menu addItemWithTitle:NSLocalizedString(@"Bring All to Front", nil)
						   action:@selector(arrangeInFront:)
					keyEquivalent:@""];
}

@end
