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
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    LOG(@"drawRect!");
    UIImage* imageBg;
    
    if (_type == UIHomeBgViewBgTypeSplash) {
        if ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4) {
            imageBg = [UIImage imageNamed:@"splash.png"];
        }else if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina5){
            imageBg = [UIImage imageNamed:@"splash-568h.png"];
        }
        
    }else if(_type == UIHomeBgViewBgTypeBg){
        if ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4) {
            imageBg = [UIImage imageNamed:@"bg.png"];
        }else if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina5){
            imageBg = [UIImage imageNamed:@"bg-568h.png"];
        }
    }
    [imageBg drawInRect:rect];
}


@end
