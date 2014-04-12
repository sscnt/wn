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
    
    
    return resultImage;
}

@end
