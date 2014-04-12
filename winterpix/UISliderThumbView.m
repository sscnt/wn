//
//  UISliderThumbVIew.m
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UISliderThumbView.h"

@implementation UISliderThumbVIew

- (id)initWithRadius:(CGFloat)radius
{
    CGRect frame = CGRectMake(0.0f, 0.0f, radius * 2.0f, radius * 2.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2.0f, 3.0f, _radius * 2.0 - 4.0f, _radius * 2.0 - 4.0f)];
    if(_locked){
        [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    }else{
        [[UIColor colorWithWhite:1.0f alpha:1.0f] setFill];
    }
    [ovalPath fill];
    [[UIColor colorWithWhite:26.0f/255.0f alpha:1.0f] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
}

@end
