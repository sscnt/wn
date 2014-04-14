//
//  Processor.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "Processor.h"

float absf(float v){
    if (v < 0.0f) {
        return -v;
    }
    return v;
}

@implementation Processor

static Processor* sharedProcessor = nil;

+ (Processor*)instance {
	@synchronized(self) {
		if (sharedProcessor == nil) {
			sharedProcessor = [[self alloc] init];
		}
	}
	return sharedProcessor;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedProcessor == nil) {
			sharedProcessor = [super allocWithZone:zone];
			return sharedProcessor;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone {
	return self;  // シングルトン状態を保持するため何もせず self を返す
}

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

+ (void)reset
{
    [[Processor instance] reset];
}

- (void)reset
{
    _opacity = 1.0f;
    _temp = 1.0f;
    _snowfall = 0.40f;
    _snowDirection = -0.20f;
}

#pragma mark execution

+ (UIImage *)executeWithCurrentOriginalImage
{
    return nil;
}

+ (UIImage *)executeWithImage:(UIImage *)image
{
    return [[Processor instance] executeWithImage:image];
}

- (UIImage *)executeWithImage:(UIImage *)image
{
    MergeBlendingMode blendingMode = MergeBlendingModeNormal;
    if (_faceDetected) {
        blendingMode = MergeBlendingModeNormalSkin;
    }
    
    GPUEffectColdWinter* effect = [[GPUEffectColdWinter alloc] init];
    effect.imageToProcess = image;
    UIImage* result = [effect process];
    if (_temp != 1.0f) {
        GPUEffectAutumnToWinter* effect = [[GPUEffectAutumnToWinter alloc] init];
        effect.imageToProcess = result;
        UIImage* _image = [effect process];
        result = [Processor mergeBaseImage:result overlayImage:_image opacity:(1.0 - [Processor instance].temp) blendingMode:blendingMode];
    }
    if (_opacity != 1.0f) {
        result = [Processor mergeBaseImage:image overlayImage:result opacity:_opacity blendingMode:blendingMode];
    }
    return result;
    
}

+ (UIImage *)addSnowfallWithImage:(UIImage *)image WithSnowfallImage:(UIImage *)snowImage
{
    return [[Processor instance] addSnowfallWithImage:image WithSnowfallImage:snowImage];
}

- (UIImage *)addSnowfallWithImage:(UIImage *)image WithSnowfallImage:(UIImage *)snowImage
{
    float opacity = _opacity * _snowfall;
    int numberOfRepeat = 0;
    
    float xsign = 1.0f;
    float ysign = 1.0f;
    
    //// Small
    numberOfRepeat = roundf(MAX(0.0f, powf(opacity, 1.4)) * 6.0f);
    LOG(@"Small repeats %d times.", numberOfRepeat);
    for (int i = 0; i < numberOfRepeat; i++) {
        @autoreleasepool {
            xsign = (i % 2 == 0) ? 1.0f : -1.0f;
            ysign = ((i / 2) % 2 == 0) ? 1.0f : -1.0f;
            LOG(@"%f, %f", ysign, xsign);
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
            GPUImageMotionBlurFilter* motion = [[GPUImageMotionBlurFilter alloc] init];
            GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
            transform.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0f * xsign, 1.0f * ysign), CGAffineTransformMakeRotation(M_PI * (float)(i / 4)));
            [transform addTarget:motion];
            motion.blurAngle = _snowDirection * -60.0f - 90.0f;
            motion.blurSize = 1.0f + 2.0 * absf(_snowDirection);
            [base addTarget:transform];
            [base processImage];
            image = [Processor mergeBaseImage:image overlayImage:[motion imageFromCurrentlyProcessedOutput] opacity:1.0f blendingMode:MergeBlendingModeScreen];
        }
    }
    
    //// Medium
    numberOfRepeat = roundf(MAX(0.0f, opacity - 0.30f) * 2.4f / 0.70f);
    LOG(@"Medium repeats %d times.", numberOfRepeat);
    for (int i = 0; i < numberOfRepeat; i++) {
        @autoreleasepool {
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
            GPUImageMotionBlurFilter* motion = [[GPUImageMotionBlurFilter alloc] init];
            GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
            transform.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.8, 1.8), CGAffineTransformMakeRotation(M_PI * (float)i));
            [transform addTarget:motion];
            motion.blurAngle = _snowDirection * -60.0f - 90.0f;
            motion.blurSize = 1.0f + 4.0 * absf(_snowDirection);
            [base addTarget:transform];
            [base processImage];
            image = [Processor mergeBaseImage:image overlayImage:[motion imageFromCurrentlyProcessedOutput] opacity:1.0f blendingMode:MergeBlendingModeScreen];
        }
    }

    
    //// Large
    numberOfRepeat = roundf(MAX(0.0f, opacity - 0.10f) * 2.4f / 0.90f);
    LOG(@"Large repeats %d times.", numberOfRepeat);
    for (int i = 0; i < numberOfRepeat; i++) {
        @autoreleasepool {
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
            GPUImageMotionBlurFilter* motion = [[GPUImageMotionBlurFilter alloc] init];
            GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
            transform.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(2.6, 2.6), CGAffineTransformMakeRotation(M_PI * (float)i));
            [transform addTarget:motion];
            motion.blurAngle = _snowDirection * -60.0f - 90.0f;
            motion.blurSize = 1.0f + 6.0 * absf(_snowDirection);
            [base addTarget:transform];
            [base processImage];
            image = [Processor mergeBaseImage:image overlayImage:[motion imageFromCurrentlyProcessedOutput] opacity:1.0f blendingMode:MergeBlendingModeScreen];
        }
    }
    
    
    return image;
}


+ (UIImage*)mergeBaseImage:(UIImage *)baseImage overlayImage:(UIImage *)overlayImage opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode
{
    GPUImagePicture* overlayPicture = [[GPUImagePicture alloc] initWithImage:overlayImage];
    GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = opacity;
    [overlayPicture addTarget:opacityFilter];
    
    GPUImagePicture* basePicture = [[GPUImagePicture alloc] initWithImage:baseImage];
    
    id blending = [GPUImageEffects effectByBlendMode:blendingMode];
    [opacityFilter addTarget:blending atTextureLocation:1];
    
    [basePicture addTarget:blending];
    [basePicture processImage];
    [overlayPicture processImage];
    return [blending imageFromCurrentlyProcessedOutput];
    
}

+ (UIImage*)mergeBaseImage:(UIImage *)baseImage overlayFilter:(GPUImageFilter *)overlayFilter opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode
{
    GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = opacity;
    [overlayFilter addTarget:opacityFilter];
    
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:baseImage];
    [picture addTarget:overlayFilter];
    
    id blending = [GPUImageEffects effectByBlendMode:blendingMode];
    [opacityFilter addTarget:blending atTextureLocation:1];
    
    [picture addTarget:blending];
    [picture processImage];
    UIImage* mergedImage = [blending imageFromCurrentlyProcessedOutput];
    [picture removeAllTargets];
    [overlayFilter removeAllTargets];
    [opacityFilter removeAllTargets];
    return mergedImage;
    
}
@end
