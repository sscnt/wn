//
//  UINavigationBarButton.m
//  Vintage
//
//  Created by SSC on 2014/02/18.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UINavigationBarButton.h"

@implementation UINavigationBarButton

- (id)initWithType:(NavigationBarButtonType)type
{
    CGRect frame = CGRectMake(0.0f, 0.0f, roundf([UIScreen screenSize].width / 6.0f), 44.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)setType:(NavigationBarButtonType)type
{
    _type = type;
    [self setIcon];
}

- (void)setIcon
{
    UIImage* iconImage;
    switch (_type) {
        case NavigationBarButtonTypeBrightness:
            iconImage = [UIImage imageNamed:@"brightness-button-60.png"];
            break;
        case NavigationBarButtonTypeColor:
            iconImage = [UIImage imageNamed:@"color-button-alter-60.png"];
            break;
        case NavigationBarButtonTypeContrast:
            iconImage = [UIImage imageNamed:@"contrast-button-60.png"];
            break;
        case NavigationBarButtonTypeOpacity:
            iconImage = [UIImage imageNamed:@"opacity-button-60.png"];
            break;
        case NavigationBarButtonTypeFocus:
            iconImage = [UIImage imageNamed:@"focus-button-60.png"];
            break;
        default:
            break;
    }
    _iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    _iconImageView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f + 1.0f);
    _iconImageView.alpha = 0.70f;
    [self addSubview:_iconImageView];
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [UIColor colorWithWhite:16.0f/255.0f alpha:1.0f];
        _iconImageView.alpha = 0.90f;
    }else{
        self.backgroundColor = [UIColor clearColor];
        _iconImageView.alpha = 0.60f;
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
