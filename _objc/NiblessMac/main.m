//
//  main.m
//  Nibless
//
//  Created by Jeffrey Johnson on 6/3/07.
//  Copyright Lap Cat Software 2007. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JJBundle.h"

int main(int argc, char * argv[]) {
	[[JJBundle class] poseAsClass:[NSBundle class]];
	
    return NSApplicationMain(argc, (const char **)argv);
}
