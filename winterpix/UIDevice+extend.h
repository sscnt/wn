//
//  UIDevice+resolution.h
//  TwitterTrend
//
//  Created by SSC on 2013/05/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

enum {
    UIDeviceResolution_Unknown           = 0,
    UIDeviceResolution_iPhoneStandard    = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina4    = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina5     = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard      = 4,    // iPad 1,2,mini Standard Display   (1024x768px)
    UIDeviceResolution_iPadRetina        = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;


@interface UIDevice (extend)

+ (UIDeviceResolution)resolution;
+ (BOOL)isIOS6;
+ (BOOL)isIOS5;
+ (BOOL)underIOS7;
+ (BOOL)isiPad;
+ (BOOL)underIPhone5s;
+ (BOOL)canOpenInstagram;
+ (BOOL)canOpenTwitter;
+ (BOOL)isCurrentLanguageJapanese;


+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
