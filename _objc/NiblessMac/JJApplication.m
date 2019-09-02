//
//  JJApplication.m
//  Nibless
//
//  Created by Jeffrey Johnson on 6/3/07.
//  Copyright 2007 Lap Cat Software. All rights reserved.
//

#import "JJApplication.h"
#import "JJApplicationDelegate.h"

@implementation JJApplication

#pragma mark NSObject

-(id) init {
	if ((self = [super init])) {
		// NSApplication might not have created an autorelease pool yet, so create our own.
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		[self setDelegate:[[JJApplicationDelegate alloc] init]];
		
		[pool release];
	}
	return self;
}

-(void) dealloc {
	id delegate = [self delegate];
	if (delegate) {
		[self setDelegate:nil];
		[delegate release];
	}
	
	[super dealloc];
}

@end
