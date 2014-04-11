//
//  GPUEffectColdWinter.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUEffectColdWinter.h"

@implementation GPUEffectColdWinter

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
    
    self.effectId = EffectIdColdWinter;
    
    UIImage* resultImage = self.imageToProcess;
    
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cw1"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:21 Magenta:8 Yellow:15 Black:0];
        [selectiveColor setYellowsCyan:-31 Magenta:24 Yellow:-63 Black:0];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Channel Mixer
    @autoreleasepool {
        GPUImageChannelMixerFilter* mixerFilter = [[GPUImageChannelMixerFilter alloc] init];
        [mixerFilter setRedChannelRed:100 Green:0 Blue:0 Constant:0];
        [mixerFilter setGreenChannelRed:0 Green:100 Blue:0 Constant:0];
        [mixerFilter setBlueChannelRed:12 Green:0 Blue:64 Constant:0];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:mixerFilter opacity:0.60f blendingMode:MergeBlendingModeNormal];
    }
    
    // Channel Mixer
    @autoreleasepool {
        GPUImageChannelMixerFilter* mixerFilter = [[GPUImageChannelMixerFilter alloc] init];
        [mixerFilter setRedChannelRed:100 Green:0 Blue:0 Constant:0];
        [mixerFilter setGreenChannelRed:0 Green:100 Blue:0 Constant:0];
        [mixerFilter setBlueChannelRed:-10 Green:26 Blue:104 Constant:0];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:mixerFilter opacity:0.60f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cw2"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:0.70f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:121.0f/255.0f green:44.0f/255.0f blue:49.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.20f blendingMode:MergeBlendingModeHue];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:147.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.45f blendingMode:MergeBlendingModeDifference];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:165.0f/255.0f green:191.0f/255.0f blue:223.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.20f blendingMode:MergeBlendingModeSoftLight];
    }
    
    // Color Balance
    @autoreleasepool {
        GPUImageColorBalanceFilter* colorBalance = [[GPUImageColorBalanceFilter alloc] init];
        GPUVector3 shadows;
        shadows.one = 0.0f;
        shadows.two = 2.0f/255.0f;
        shadows.three = 5.0f/255.0f;
        [colorBalance setShadows:shadows];
        GPUVector3 midtones;
        midtones.one = 0.0f/255.0f;
        midtones.two = -1.0f/255.0f;
        midtones.three = 3.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = 11.0f/255.0f;
        highlights.two = 0.0f/255.0f;
        highlights.three = 10.0f/255.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:14 Magenta:0 Yellow:15 Black:0];
        [selectiveColor setYellowsCyan:-3 Magenta:4 Yellow:-11 Black:0];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Curve
    @autoreleasepool {
        GPUImageToneCurveFilter* curveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"cw3"];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:curveFilter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:102.0f/255.0f green:78.0f/255.0f blue:76.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.20f blendingMode:MergeBlendingModeSoftLight];
    }
    
    // Color Balance
    @autoreleasepool {
        GPUImageColorBalanceFilter* colorBalance = [[GPUImageColorBalanceFilter alloc] init];
        GPUVector3 shadows;
        shadows.one = 0.0f;
        shadows.two = 0.0f/255.0f;
        shadows.three = 12.0f/255.0f;
        [colorBalance setShadows:shadows];
        GPUVector3 midtones;
        midtones.one = 12.0f/255.0f;
        midtones.two = 10.0f/255.0f;
        midtones.three = 13.0f/255.0f;
        [colorBalance setMidtones:midtones];
        GPUVector3 highlights;
        highlights.one = -9.0f/255.0f;
        highlights.two = 13.0f/255.0f;
        highlights.three = 17.0f/255.0f;
        [colorBalance setHighlights:highlights];
        colorBalance.preserveLuminosity = YES;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:colorBalance opacity:0.40f blendingMode:MergeBlendingModeNormal];
    }
    
    // Hue/Saturation
    @autoreleasepool {
        GPUImageHueSaturationFilter* solidColor = [[GPUImageHueSaturationFilter alloc] init];
        solidColor.colorize = YES;
        solidColor.saturation = 27.0f;
        solidColor.hue = 196;
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.30f blendingMode:MergeBlendingModeNormal];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:181.0f/255.0f green:145.0f/255.0f blue:124.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.30f blendingMode:MergeBlendingModeLinearLight];
    }
    
    // Fill Layer
    @autoreleasepool {
        GPUImageSolidColorGenerator* solidColor = [[GPUImageSolidColorGenerator alloc] init];
        [solidColor setColorRed:236.0f/255.0f green:52.0f/255.0f blue:52.0f/255.0 alpha:1.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:solidColor opacity:0.30f blendingMode:MergeBlendingModeHue];
    }
    
    return resultImage;
}

@end
