//
//  UIDevice+resolution.m
//  TwitterTrend
//
//  Created by SSC on 2013/05/01.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDevice+extend.h"

@implementation UIDevice (Gravy)

+ (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina5;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

+ (NSString*) machineName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *result = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return result;
}

+ (BOOL)isIOS6
{
    NSArray  *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor  = [[aOsVersions objectAtIndex:0] intValue];
    if (iOsVersionMajor >= 7)
    {
        return NO;
    }
    if (iOsVersionMajor < 6)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)underIOS7
{
    NSArray  *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor  = [[aOsVersions objectAtIndex:0] intValue];
    if (iOsVersionMajor < 7)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isIOS5
{
    NSArray  *aOsVersions = [[[UIDevice currentDevice]systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor  = [[aOsVersions objectAtIndex:0] intValue];
    if (iOsVersionMajor >= 6)
    {
        return NO;
    }
    return YES;
}

+ (BOOL) isiPad {NSString *deviceModel = (NSString*)[UIDevice currentDevice].model;
    
    if ([[deviceModel substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
    //return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad;
}

+ (BOOL)underIPhone5s
{
    NSError *error = nil;
    NSString* name = [UIDevice machineName];
    NSString *pattern = @"iPhone([0-9]+),";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSTextCheckingResult *match = [regexp firstMatchInString:name options:0 range:NSMakeRange(0, name.length)];

    if(match.numberOfRanges == 2){
        int version = [[name substringWithRange:[match rangeAtIndex:1]] intValue];
        if(version >= 6.0){
            return NO;
        }
    }
    return YES;
}

+ (BOOL)canOpenInstagram{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        return YES;
    }
    return NO;
}

+ (BOOL)canOpenTwitter{
    NSURL *instagramURL = [NSURL URLWithString:@"twitter://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isCurrentLanguageJapanese
{
    NSArray *langs = [NSLocale preferredLanguages];
    NSString *currentLanguage = [langs objectAtIndex:0];
    if([currentLanguage compare:@"ja"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}


+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        LOG(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
