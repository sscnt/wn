//
//  UICloseButton.m
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UICloseButton.h"

@implementation UICloseButton

- (id)init
{
    CGRect frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.alpha = 0.50f;
    }else{
        self.alpha = 1.0f;
    }
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.8];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(23.41, 22)];
    [bezierPath addLineToPoint: CGPointMake(29.07, 27.66)];
    [bezierPath addLineToPoint: CGPointMake(27.66, 29.07)];
    [bezierPath addLineToPoint: CGPointMake(22, 23.41)];
    [bezierPath addLineToPoint: CGPointMake(16.34, 29.07)];
    [bezierPath addLineToPoint: CGPointMake(14.93, 27.66)];
    [bezierPath addLineToPoint: CGPointMake(20.59, 22)];
    [bezierPath addLineToPoint: CGPointMake(14.93, 16.34)];
    [bezierPath addLineToPoint: CGPointMake(16.34, 14.93)];
    [bezierPath addLineToPoint: CGPointMake(22, 20.59)];
    [bezierPath addLineToPoint: CGPointMake(27.66, 14.93)];
    [bezierPath addLineToPoint: CGPointMake(29.07, 16.34)];
    [bezierPath addLineToPoint: CGPointMake(23.41, 22)];
    [bezierPath closePath];
    [color setFill];
    [bezierPath fill];
    
    


}


@end
