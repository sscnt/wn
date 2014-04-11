//
//  GPUSaturationImageFilter.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/27.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUAdjustmentsSaturationFragmentShaderString;

@interface GPUAdjustmentsSaturation : GPUImageFilter
{
    GLuint saturationUniform;
    GLuint vibranceUniform;
}

@property (nonatomic, readwrite) float vibrance;
@property (nonatomic, readwrite) float saturation;

@end
