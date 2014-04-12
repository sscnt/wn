//
//  UISliderContainer.m
//  Vintage
//
//  Created by SSC on 2014/03/10.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UISliderContainer.h"

@implementation UISliderContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    if(locked){
        self.alpha = 0.30f;
    }else{
        __block UISliderContainer* _self = self;
        [UIView animateWithDuration:0.20f animations:^{
            _self.alpha = 1.0f;
        } completion:nil];
        
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
