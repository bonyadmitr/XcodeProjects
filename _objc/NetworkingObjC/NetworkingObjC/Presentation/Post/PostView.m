//
//  PostView.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "PostView.h"

@interface PostView ()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation PostView

static NSString * const longTextForScroll = @"Objective-C is a general-purpose, object-oriented programming language that adds Smalltalk-style messaging to the C programming language. It was the main programming language used by Apple for the OS X and iOS operating systems, and their respective application programming interfaces (APIs) Cocoa and Cocoa Touch prior to the introduction of Swift. The programming language Objective-C was originally developed in the early 1980s. It was selected as the main language used by NeXT for its NeXTSTEP operating system, from which OS X and iOS are derived.[3] Portable Objective-C programs that do not use the Cocoa or Cocoa Touch libraries, or those using parts that may be ported or reimplemented for other systems, can also be compiled for any system supported by GNU Compiler Collection (GCC) or Clang.";

- (void)fillWith:(Post *)post {

    
    self.idLabel.text = [@(post.id) stringValue]; /// 1st way int to string
    self.userIdLabel.text = [NSString stringWithFormat:@"%ld", (long)post.userId]; /// 2nd way int to string
    self.titleLabel.text = post.title;
    self.bodyLabel.text =  [NSString stringWithFormat:@"%@\n\n\n%@", post.body, longTextForScroll];
}

@end
