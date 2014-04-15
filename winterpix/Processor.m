//
//  Processor.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "Processor.h"
#define ARC4RANDOM_MAX      0x100000000

float randFloat(float a, float b)
{
    return ((b-a)*((float)arc4random()/ARC4RANDOM_MAX))+a;
}

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
    _snowfall = 0.30f;
    _snowDirection = -0.50f;
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
    
    UIImage* result = image;
    
    if (_brightness != 0.0f) {
        GPUimageTumblinBrightnessFilter* filter = [[GPUimageTumblinBrightnessFilter alloc] init];
        filter.brightness = _brightness;
        
        result = [Processor mergeBaseImage:result overlayFilter:filter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    if (_temp != 1.0f) {
        GPUEffectColdWinter* effect = [[GPUEffectColdWinter alloc] init];
        effect.imageToProcess = result;
        UIImage* _image = [effect process];
        result = [Processor mergeBaseImage:result overlayImage:_image opacity:(1.0 - _temp) blendingMode:MergeBlendingModeNormal];
    }

    if (_opacity != 0.0f) {
        GPUEffectAutumnToWinter* effect = [[GPUEffectAutumnToWinter alloc] init];
        effect.imageToProcess = result;
        effect.lightness = (1.0 - _opacity) * 5.0f;
        UIImage* _image = [effect process];
        result = [Processor mergeBaseImage:result overlayImage:_image opacity:_opacity blendingMode:MergeBlendingModeNormal];
    }
    
    return result;
    
}

+ (UIImage *)addFogToImage:(UIImage *)image WithFogImage:(UIImage *)snowImage
{
    return [[Processor instance] addFogToImage:image WithFogImage:snowImage];
}

- (UIImage *)addFogToImage:(UIImage *)image WithFogImage:(UIImage *)snowImage
{
    image = [Processor mergeBaseImage:image overlayImage:snowImage opacity:_snowfall / 1.60f blendingMode:MergeBlendingModeNormal];
    return image;
}

+ (UIImage *)addSnowfallToImage:(UIImage *)image WithSnowfallImage:(UIImage *)snowImage
{
    return [[Processor instance] addSnowfallToImage:image WithSnowfallImage:snowImage];
}

- (UIImage *)addSnowfallToImage:(UIImage *)image WithSnowfallImage:(UIImage *)snowImage
{
    float opacity = _snowfall;
    int numberOfRepeat = 0;
    
    CGFloat scale = snowImage.size.width / [CurrentImage originalImageSize].width;
    LOG_SIZE(snowImage.size);
    
    float xsign = 1.0f;
    float ysign = 1.0f;

    srand((unsigned)time(NULL));
    //// Small
    numberOfRepeat = roundf(MAX(0.0f, opacity) * 8.4f);
    LOG(@"Small repeats %d times.", numberOfRepeat);
    for (int i = 0; i < numberOfRepeat; i++) {
        @autoreleasepool {
            xsign = (i % 2 == 0) ? 1.0f : -1.0f;
            ysign = ((i / 2) % 2 == 0) ? 1.0f : -1.0f;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
            GPUImageLensMotionBlurFilter* motion = [[GPUImageLensMotionBlurFilter alloc] init];
            GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
            transform.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0f * xsign, 1.0f * ysign), CGAffineTransformMakeRotation(M_PI * (float)(i / 4)));
            [transform addTarget:motion];
            motion.blurAngle = _snowDirection * (1.0f + randFloat(0.0f, 0.30f)) * -60.0f - 90.0f;
            motion.blurSize = 2.0f * absf(_snowDirection) * scale;
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
            GPUImageLensMotionBlurFilter* motion = [[GPUImageLensMotionBlurFilter alloc] init];
            GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
            transform.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(2.0f, 2.0f), CGAffineTransformMakeRotation(M_PI * (float)i));
            [transform addTarget:motion];
            motion.blurAngle = _snowDirection * (1.0f + randFloat(0.0f, 0.30f)) * -60.0f - 90.0f;
            LOG(@"angle: %f", motion.blurAngle);
            motion.blurSize = 3.0f * absf(_snowDirection) * scale;
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
            GPUImageLensMotionBlurFilter* motion = [[GPUImageLensMotionBlurFilter alloc] init];
            GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
            transform.affineTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(3.0, 3.0), CGAffineTransformMakeRotation(M_PI * (float)i));
            [transform addTarget:motion];
            motion.blurAngle = _snowDirection * (1.0f + randFloat(0.0f, 0.30f)) * -60.0f - 90.0f;
            motion.blurSize = 4.0f * absf(_snowDirection) * scale;
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
