//
//  GPUImageSummerToWinter.m
//  Winterpix
//
//  Created by SSC on 2014/04/15.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUEffectSummerToWinter.h"

@implementation GPUEffectSummerToWinter

- (id)init
{
    self = [super init];
    if(self){
        self.defaultOpacity = 1.0f;
        self.faceOpacity = 1.0f;
        self.effectId = EffectIdSummerToWinter;
    }
    return self;
}

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setYellowsCyan:0 Magenta:0 Yellow:0 Black:-100];
        [selectiveColor setGreensCyan:0 Magenta:0 Yellow:0 Black:-100];
        [selectiveColor setNeutralsCyan:0 Magenta:0 Yellow:0 Black:-35];
        [selectiveColor setBlacksCyan:0 Magenta:0 Yellow:0 Black:100];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    resultImage = [self mergeBaseImage:resultImage overlayImage:resultImage opacity:0.54f blendingMode:MergeBlendingModeColorBurn];
    
    // Replace color
    @autoreleasepool {
        GPUImageReplaceColorFilter* filter = [[GPUImageReplaceColorFilter alloc] init];
        filter.saturation = -100.0f;
        filter.lightness = 0.80f;
        [filter setSelectionColorRed:204.0f/255.0f Green:204.0f/255.0f Blue:204.0f/255.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:filter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    return resultImage;
}

@end
