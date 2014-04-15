//
//  Processor.h
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUEffectAutumnToWinter.h"
#import "GPUEffectColdWinter.h"
#import "GPUEffectSummerToWinter.h"
#import "GPUImageEffects.h"
#import "GPUimageTumblinBrightnessFilter.h"
#import "GPUImageLensMotionBlurFilter.h"


@protocol ProcessorDelegate <NSObject>
@optional


@end

@interface Processor : NSObject

@property (nonatomic, assign) BOOL faceDetected;
@property (nonatomic, assign) float opacity;
@property (nonatomic, assign) float temp;
@property (nonatomic, assign) float snowfall;
@property (nonatomic, assign) float snowDirection;
@property (nonatomic, assign) float brightness;

+ (Processor*)instance;
+ (void)reset;
- (void)reset;

+ (UIImage*)executeWithImage:(UIImage*)image;
- (UIImage*)executeWithImage:(UIImage*)image;

+ (UIImage*)addSnowfallToImage:(UIImage*)image WithSnowfallImage:(UIImage*)snowImage;
- (UIImage*)addSnowfallToImage:(UIImage*)image WithSnowfallImage:(UIImage*)snowImage;

+ (UIImage*)addFogToImage:(UIImage*)image WithFogImage:(UIImage*)snowImage;
- (UIImage*)addFogToImage:(UIImage*)image WithFogImage:(UIImage*)snowImage;

+ (UIImage*)executeWithCurrentOriginalImage;

+ (UIImage*)mergeBaseImage:(UIImage*)baseImage overlayImage:(UIImage*)overlayImage opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode;
+ (UIImage*)mergeBaseImage:(UIImage*)baseImage overlayFilter:(GPUImageFilter*)overlayFilter opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode;

@end
