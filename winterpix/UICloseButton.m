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

        UIImageView* view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close-60.png"]];
        view.alpha = 0.80f;
        view.center = CGPointMake(frame.size.width / 2.0f, frame.size.height / 2.0f);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
