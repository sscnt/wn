//
//  GPUEffectAutumnToWinter.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "GPUEffectAutumnToWinter.h"

@implementation GPUEffectAutumnToWinter

- (id)init
{
    self = [super init];
    if(self){
        self.defaultOpacity = 1.0f;
        self.faceOpacity = 1.0f;
        self.effectId = EffectIdAutumnToWinter;
    }
    return self;
}

- (UIImage*)process
{
    UIImage* resultImage = self.imageToProcess;
    
    // Selective Color
    @autoreleasepool {
        GPUImageSelectiveColorFilter* selectiveColor = [[GPUImageSelectiveColorFilter alloc] init];
        [selectiveColor setRedsCyan:0 Magenta:0 Yellow:0 Black:-100];
        [selectiveColor setYellowsCyan:0 Magenta:0 Yellow:0 Black:-100];
        [selectiveColor setBlacksCyan:0 Magenta:0 Yellow:0 Black:40];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:selectiveColor opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    // Replace color
    @autoreleasepool {
        GPUImageReplaceColorFilter* filter = [[GPUImageReplaceColorFilter alloc] init];
        filter.saturation = 0.0f;
        filter.lightness = 0.80f;
        [filter setSelectionColorRed:204.0f/255.0f Green:204.0f/255.0f Blue:204.0f/255.0f];
        
        resultImage = [self mergeBaseImage:resultImage overlayFilter:filter opacity:1.0f blendingMode:MergeBlendingModeNormal];
    }
    
    
    return resultImage;
}

@end
