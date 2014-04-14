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
    NSString* filename;
    
    if (_type == UIHomeBgViewBgTypeSplash) {
        if ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4) {
            filename = @"Default@2x.png";
        }else if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina5){
            filename = @"Default-568h@2x.png";
        }
        
    }else if(_type == UIHomeBgViewBgTypeBg){
        if ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4) {
            filename = @"bg@2x.png";
        }else if([UIDevice resolution] == UIDeviceResolution_iPhoneRetina5){
            filename = @"bg-568h@2x.png";
        }
    }
    NSString* snowPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    
    UIImage* imageBg = [[UIImage alloc] initWithContentsOfFile:snowPath];
    [imageBg drawInRect:rect];
}


@end
