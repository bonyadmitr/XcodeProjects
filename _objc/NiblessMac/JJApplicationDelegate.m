//
//  JJApplicationDelegate.m
//  Nibless
//
//  Created by Jeffrey Johnson on 6/3/07.
//  Copyright 2007 Lap Cat Software. All rights reserved.
//

#import "JJApplicationDelegate.h"
#import "JJMenuPopulator.h"

@implementation JJApplicationDelegate

#pragma mark NSObject

-(id) init {
	if ((self = [super init])) {
		m_applicationName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] retain];
		if (!m_applicationName) {
			NSLog(@"![[NSBundle mainBundle] objectForInfoDictionaryKey:@\"CFBundleName\"]");
			m_applicationName = [NSLocalizedString(@"Nibless", @"The name of this application") retain];
		}
	}
	return self;
}

-(void) dealloc {
	[m_applicationName release];
	m_applicationName = nil;
	
	[super dealloc];
}

#pragma mark NSApplication delegate

-(void) applicationWillFinishLaunching:(NSNotification *)aNotification {
	// NSApplication might not have created an autorelease pool yet, so create our own.
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	[JJMenuPopulator populateMainMenu];
	
	[[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:@"/Developer/About Xcode Tools.pdf"]];
	
	[pool release];
}

#pragma mark JJApplicationDelegate

-(NSString *) applicationName {
	return [[m_applicationName retain] autorelease];
}

@end
