//
//  GPUImageEffects.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/04.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageEffects.h"

@implementation GPUImageEffects

- (id)init
{
    self = [super init];
    if(self){
        self.defaultOpacity = 1.0f;
        self.faceOpacity = 1.0f;
    }
    return self;
}

- (UIImage*)process
{
    return nil;
}

- (UIImage*)mergeBaseImage:(UIImage *)baseImage overlayImage:(UIImage *)overlayImage opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode
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

- (UIImage*)mergeBaseImage:(UIImage *)baseImage overlayFilter:(GPUImageFilter *)overlayFilter opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode
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

+ (id)effectByBlendMode:(MergeBlendingMode)mode
{
    id blending;
    if(mode == MergeBlendingModeNormal){
        blending = [[GPUImageNormalBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeDarken){
        blending = [[GPUImageDarkenBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeMultiply){
        blending = [[GPUImageMultiplyBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeScreen){
        blending = [[GPUImageScreenBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeSoftLight){
        blending = [[GPUImageSoftLightBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeLighten){
        blending = [[GPUImageLightenBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeHardLight){
        blending = [[GPUImageHardLightBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeVividLight){
        blending = [[GPUImageVividLightBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeOverlay){
        blending = [[GPUImageOverlayBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeColorDodge){
        blending = [[GPUImageColorDodgeBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeLinearDodge){
        blending = [[GPUImageLinearDodgeBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeLinearLight){
        blending = [[GPUImageLinearLightBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeDarkerColor){
        blending = [[GPUImageDarkerColorBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeExclusion){
        blending = [[GPUImageExclusionBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeColor){
        blending = [[GPUImageColorBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeHue){
        blending = [[GPUImageHueBlendAltFIlter alloc] init];
    }
    if(mode == MergeBlendingModeColorBurn){
        blending = [[GPUImageColorBurnBlendFilter alloc] init];
    }
    if(mode == MergeBlendingModeSaturation){
        blending = [[GPUImageSaturationBlendAltFilter alloc] init];
    }
    if(mode == MergeBlendingModeDifference){
        blending = [[GPUImageDifferenceBlendFilter alloc] init];
    }
    return blending;
}

@end
