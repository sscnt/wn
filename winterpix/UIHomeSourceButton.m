//
//  UIHomeSourceButton.m
//  Winterpix
//
//  Created by SSC on 2014/04/11.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "UIHomeSourceButton.h"

@implementation UIHomeSourceButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setIconType:(UIHomeSourceButtonIconType)iconType
{
    UIImage* iconImage;
    switch (iconType) {
        case UIHomeSourceButtonIconTypeCamera:
            iconImage = [UIImage imageNamed:@"home-camera.png"];
            break;
        case UIHomeSourceButtonIconTypePhotos:
            iconImage = [UIImage imageNamed:@"home-photos.png"];
            break;
        default:
            break;
    }
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    imgView.image = iconImage;
    imgView.alpha = 0.80f;
    imgView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    [self addSubview:imgView];
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
    UIColor* color = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.0f];
    UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.60f];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2.0f, 2.0f, rect.size.width - 4.0f, rect.size.height - 4.0f)];
    [color setFill];
    [ovalPath fill];
    [color2 setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];  

}


@end
