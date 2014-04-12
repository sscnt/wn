//
//  UIEditorDialogBgImageView.m
//  Vintage
//
//  Created by SSC on 2014/03/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UIEditorDialogBgImageView.h"

@implementation UIEditorDialogBgImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate touchesBeganWithBackgroundImageView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate touchesEndedWithBackgroundImageView:self];
}

@end
