//
//  UISaveButton.m
//  Vintage
//
//  Created by SSC on 2014/02/16.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UISaveButton.h"

@implementation UISaveButton

- (id)init
{
    CGRect frame = CGRectMake(0.0f, 0.0f, roundf([UIScreen screenSize].width / 6.0f), 44.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:99.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
        
        UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save-cloud-60.png"]];
        view.center = CGPointMake(frame.size.width / 2.0f, 22.0f);
        [self addSubview:view];
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
    CGFloat y = 0.0f;
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0.0f, y)];
    [bezierPath addLineToPoint: CGPointMake(rect.size.width, y)];
    [[UIColor blackColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
}
@end
