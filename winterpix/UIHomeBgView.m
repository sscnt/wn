//
//  UIHomeBgView.m
//  winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UIHomeBgView.h"

@implementation UIHomeBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
    }
    return self;
}

- (void)setBgImage:(UIImage *)bgImage
{
    _imageView.image = bgImage;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if(_imageView.image){
        [_imageView.image drawInRect:rect];
        _imageView.image = nil;
        _imageView = nil;
    }
}


@end
