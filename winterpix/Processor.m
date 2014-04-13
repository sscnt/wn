//
//  Processor.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "Processor.h"

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
        _opacity = 1.0f;
        _temp = 1.0f;
        
    }
    return self;
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
    GPUEffectColdWinter* effect = [[GPUEffectColdWinter alloc] init];
    effect.imageToProcess = image;
    UIImage* result = [effect process];
    if (_temp != 1.0f) {
        GPUEffectAutumnToWinter* effect = [[GPUEffectAutumnToWinter alloc] init];
        effect.imageToProcess = result;
        UIImage* _image = [effect process];
        result = [Processor mergeBaseImage:result overlayImage:_image opacity:(1.0 - [Processor instance].temp) blendingMode:MergeBlendingModeNormal];
    }
    if (_opacity != 1.0f) {
        result = [Processor mergeBaseImage:image overlayImage:result opacity:_opacity blendingMode:MergeBlendingModeNormal];
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
    GPUImageGaussianBlurFilter* blur = [[GPUImageGaussianBlurFilter alloc] init];
    blur.blurRadiusInPixels = 1.0f;
    
    @autoreleasepool {
        GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
        GPUImageMotionBlurFilter* motion = [[GPUImageMotionBlurFilter alloc] init];
        motion.blurAngle = -50.0f;
        motion.blurSize = 1.0f;
        [base addTarget:motion];
        [base processImage];
        image = [Processor mergeBaseImage:image overlayImage:[motion imageFromCurrentlyProcessedOutput] opacity:1.0f blendingMode:MergeBlendingModeScreen];
    }
    
    @autoreleasepool {
        GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
        GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
        transform.affineTransform = CGAffineTransformMakeScale(2.0f, 2.0f);
        GPUImageMotionBlurFilter* motion = [[GPUImageMotionBlurFilter alloc] init];
        motion.blurAngle = -50.0f;
        motion.blurSize = 2.0f;
        [transform addTarget:motion];
        [base addTarget:transform];
        [base processImage];
        image = [Processor mergeBaseImage:image overlayImage:[motion imageFromCurrentlyProcessedOutput] opacity:1.0f blendingMode:MergeBlendingModeScreen];
    }
    
    
    @autoreleasepool {
        GPUImageTransformFilter* transform = [[GPUImageTransformFilter alloc] init];
        GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:snowImage];
        transform.affineTransform = CGAffineTransformMakeScale(4.0f, 4.0f);
        GPUImageMotionBlurFilter* motion = [[GPUImageMotionBlurFilter alloc] init];
        motion.blurAngle = -70.0f;
        motion.blurSize = 2.0f;
        [transform addTarget:motion];
        [base addTarget:transform];
        [base processImage];
        image = [Processor mergeBaseImage:image overlayImage:[motion imageFromCurrentlyProcessedOutput] opacity:1.0f blendingMode:MergeBlendingModeScreen];
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
