//
//  PhotoCell.m
//  ImagesObjc
//
//  Created by Bondar Yaroslav on 12/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.opaque = YES;
        [self addSubview: _imageView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
