//
//  UIScrollView+m.m
//  Minority
//
//  Created by SSC on 2013/03/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIScrollView+extend.h"

@implementation UIScrollView (extend)

-(void)adjustContentSize
{
    CGFloat height = 0.0;
    for(UIView* view in [self subviews]){
        height = MAX(height, view.frame.origin.y + view.frame.size.height);
    }
    [self setContentSize:CGSizeMake(self.bounds.size.width, height)];
}
-(void)removeAllSubviews
{
    for(UIView* view in [self subviews]){
        [view removeFromSuperview];
    }

}
-(void)append:(UIView*)view
{
    
}

@end
