//
//  PostCell.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 25/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)fillWith:(Post *)post {
    self.textLabel.text = post.title;
    self.detailTextLabel.text = post.body;
}

@end
