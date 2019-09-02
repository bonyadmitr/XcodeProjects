//
//  JJBundle.m
//  Nibless
//
//  Created by Jeffrey Johnson on 6/9/07.
//  Copyright 2007 Lap Cat Software. All rights reserved.
//

#import "JJBundle.h"

@implementation JJBundle

#pragma mark NSBundle

+(BOOL) loadNibNamed:(NSString *)aNibNamed owner:(id)owner {
	if (!aNibNamed && owner == NSApp) {
		// We're lying here. Don't load anything.
		return YES;
	} else {
		return [super loadNibNamed:aNibNamed owner:owner];
	}
}

@end
